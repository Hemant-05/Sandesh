import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chattingId;

  ChatScreen({super.key, required this.userMap, required this.chattingId});

  final TextEditingController _msg = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage(String message) async {
    Map<String, dynamic> mesMap = {
      'sendBy': _auth.currentUser?.displayName,
      'message': message,
      'time': FieldValue.serverTimestamp(),
    };
    await _firestore
        .collection('chatroom')
        .doc(chattingId)
        .collection('chats')
        .add(mesMap);
    _msg.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userMap['name'],
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder<QuerySnapshot>(
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: snapshot.data?.docs[index]['sendBy'] ==
                                    _auth.currentUser?.displayName
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                           width: size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: snapshot.data?.docs[index]['sendBy'] ==
                                    _auth.currentUser?.displayName ? Colors.blue : Colors.grey,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4) ,
                              margin: EdgeInsets.all(3),
                              child: Text(snapshot.data?.docs[index]['message'],style: TextStyle(fontSize: 18),),
                            )
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                  stream: _firestore
                      .collection('chatroom')
                      .doc(chattingId)
                      .collection('chats').orderBy('time',descending: false)
                      .snapshots(),
                ),
              ),
            ),
            heightGap(4),
            Container(
              height: 60,
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: _msg,
                      decoration: InputDecoration(
                        label: Text('Type message...'),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  widthGap(10),
                  IconButton(
                    icon: Icon(Icons.send_rounded),
                    onPressed: () {
                      String msg = _msg.value.text;
                      if (!msg.isEmpty) {
                        onSendMessage(msg);
                      } else {
                        showSnackBar(context, 'Write something');
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
