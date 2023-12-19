import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Group_Works/GroupsScreen.dart';
import 'package:sandesh/Screens/HomeScreen.dart';

class AddMembers extends StatefulWidget {
  final String groupId;
  final String groupName;
  final List membersList;

  const AddMembers(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.membersList});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController searchUser = TextEditingController();
  List membersList = [];
  List newMembersList = [];
  Map<String, dynamic>? userMap;
  String addedUserName = '';

  @override
  void initState() {
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch(String search) async {
    try {
      _firestore
          .collection('users')
          .where('name', isEqualTo: search)
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs[0].data();
        });
      });
    } catch (e) {
      print(e);
      userMap = null;
    }
  }

  void onSearchResult() async {
    bool isAlreadyExist = false;
    Map<String, dynamic> temp;
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap?['uid']) isAlreadyExist = true;
    }
    if (!isAlreadyExist) {
      setState(() {
        temp = {
          'name': userMap?['name'],
          'email': userMap?['email'],
          'uid': userMap?['uid'],
          'isAdmin': false,
        };
        membersList.add(temp);
        newMembersList.add(temp);
        addedUserName = '$addedUserName${userMap?['name']}, ';
        userMap = null;
      });
    } else {
      showSnackBar(context, '${userMap?['name']} Already Added !');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Members..'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            userMap != null
                ? ListTile(
                    leading: Icon(Icons.person),
                    title: Text('${userMap?['name']}'),
                    subtitle: Text('${userMap?['email']}'),
                    trailing: IconButton(
                        icon: Icon(Icons.done), onPressed: onSearchResult),
                  )
                : Container(),
            TextField(
              controller: searchUser,
              decoration: InputDecoration(
                  label: Text('Search User with their name'),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            heightGap(10),
            ElevatedButton(
              onPressed: () {
                String search = searchUser.value.text;
                onSearch(search);
                searchUser.clear();
              },
              child: Text('Search'),
            ),
            heightGap(10),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: membersList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(membersList[index]['name']),
                    subtitle: Text(membersList[index]['email']),
                    leading: Icon(Icons.person),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          await _firestore.collection('groups').doc(widget.groupId).update(
            {
              'members': membersList,
            },
          );
          await _firestore
              .collection('groups')
              .doc(widget.groupId)
              .collection('chats')
              .add({
            'message': '${_auth.currentUser?.displayName} added $addedUserName',
            'type': 'notify',
            'time': FieldValue.serverTimestamp(),
          });
          for(int i = 0 ; i<newMembersList.length; i++){
            String uid = newMembersList[i]['uid'];
            await _firestore.collection('users')
            .doc(uid)
            .collection('groups')
            .doc(widget.groupId)
            .set({
              'name' : widget.groupName,
              'id' : widget.groupId,
            });
          }
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => GroupsScreen()),
              (route) => false);
        },
      ),
    );
  }
}
