import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Group_Works/Create_Group/AddMembersInGroup.dart';
import 'package:sandesh/Group_Works/Create_Group/CreateNewGroup.dart';
import 'package:sandesh/Group_Works/GroupChatScreen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List groupList = [];

  @override
  void initState() {
    super.initState();
    getAvailableGroup();
  }

  void getAvailableGroup() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('groups')
        .get()
        .then(
      (value) {
        setState(() {
          groupList = value.docs;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        backgroundColor: Colors.blue,
      ),
      body: groupList.length == 0
          ? const Center(
              child: Text(
                'No Groups',
                style: TextStyle(fontSize: 30),
              ),
            )
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(
                          groupId: groupList[index]['id'],
                          groupName: groupList[index]['name'],
                        ),
                      ),
                    );
                  },
                  title: Text(
                    groupList[index]['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(
                    Icons.groups,
                    size: 30,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMembersInGroup(),
            ),
          );
        },
        tooltip: 'Create New Group',
        child: const Icon(Icons.add),
      ),
    );
  }
}
