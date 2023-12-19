import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Group_Works/GroupInfoScreen.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;
final String groupId;
  const GroupChatScreen({required this.groupName, super.key, required this.groupId});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController gChatController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void onSendMessage(String msg)async{
  Map<String,dynamic> chatData = {
    'sendBy': _auth.currentUser?.displayName,
    'message' : msg,
    'type' : 'text',
    'time' : FieldValue.serverTimestamp(),
  };
  await  _firestore.collection('groups').doc(widget.groupId).collection('chats').add(chatData);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.groupName),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupInfoScreen(groupId: widget.groupId,groupName: widget.groupName,),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert))
          ],
          backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('groups').doc(widget.groupId).collection('chats').orderBy('time').snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  return SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context,index){
                      Map<String,dynamic> map = snapshot.data?.docs[index].data() as Map<String,dynamic>;
                      return messageBuilder(map);
                    }),
                  );
                }else{
                  return Container();
                }
              },
            )
          ),
          heightGap(5),
          // sending button and chat text field
          Container(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: gChatController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.photo),
                          onPressed: () {},
                        ),
                        hintText: 'Type here.....',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String chat = gChatController.value.text;
                    if(chat.isEmpty){
                      showSnackBar(context, 'Write something !');
                    }else{
                      onSendMessage(chat);
                      gChatController.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    size: 30,
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageBuilder(Map<String, dynamic> map) {
  bool check = map['sendBy'] == _auth.currentUser?.displayName;
  String name = check? 'You' : '${map['sendBy']}';
        if (map['type'] == 'text') {
          return Container(
            alignment: map['sendBy'] == _auth.currentUser?.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    map['message'],
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        } else if (map['type'] == 'img') {
          return Container(
            alignment: map['sendBy'] == _auth.currentUser?.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text(
                    '$name',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Image.network(map['message'])
                ],
              ),
            ),
          );
        } else if (map['type'] == 'notify') {
          return Container(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8),),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Text(
                  map['message'],
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          );
        } else {
          return Container(
            child: Text('Error'),
          );
        }
  }
}
