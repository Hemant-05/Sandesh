import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Screens/HomeScreen.dart';
import 'package:uuid/uuid.dart';

class CreateNewGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateNewGroup({required this.membersList, super.key});

  @override
  State<CreateNewGroup> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  final TextEditingController groupNameCon = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createGroup(String groupName) async {
    String groupId = Uuid().v1();
    await _firestore.collection('groups').doc(groupId).set({
      'members': widget.membersList,
      'id': groupId,
    });

    for (int i = 0; i < widget.membersList.length; i++){
      String uid = widget.membersList[i]['uid'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set(
        {
          'name': groupName,
          'id': groupId,
        },
      );
    }
    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      'message' : '${_auth.currentUser?.displayName} created this group',
      'type' : 'notify',
      'time' : FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Group.....'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: groupNameCon,
              decoration: InputDecoration(
                  label: Text('Enter group Name'),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            heightGap(10),
            ElevatedButton(
              onPressed: (){
                createGroup(groupNameCon.value.text);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomeScreen(currentUserData: {},)), (route) => false);
              },
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
