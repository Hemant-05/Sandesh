import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Group_Works/AddMembers.dart';
import 'package:sandesh/Group_Works/Create_Group/AddMembersInGroup.dart';
import 'package:sandesh/Group_Works/GroupsScreen.dart';
import 'package:sandesh/Screens/HomeScreen.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupInfoScreen(
      {required this.groupName, required this.groupId, super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List membersList = [];

  bool checkAdmin() {
    bool isAdmin = false;
    for (var element in membersList) {
      if (element['uid'] == _auth.currentUser?.uid) {
        isAdmin = element['isAdmin'];
      }
    }
    return isAdmin;
  }

  Future<bool> removeMember(int index) async {
    bool isDeleted = false;
    if (checkAdmin()) {
      Map<String, dynamic> removeUser = membersList[index];
      String? admin = _auth.currentUser?.displayName;
      membersList.removeAt(index);
      setState(() {});
      await _firestore.collection('groups').doc(widget.groupId).update({
        'members': membersList,
      });
      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .add({
        'message': '${admin} removed ${removeUser['name']}',
        'type': 'notify',
        'time': FieldValue.serverTimestamp(),
      });
      await _firestore
          .collection('users')
          .doc(removeUser['uid'])
          .collection('groups')
          .doc(widget.groupId)
          .delete();
      isDeleted = true;
    } else {
      showSnackBar(context, 'You can not remove members');
    }
    return isDeleted;
  }

  void leaveUser() async {
    if (!checkAdmin()) {
      String? uid = _auth.currentUser?.uid;
      String? name = _auth.currentUser?.displayName;
      await _firestore
          .collection('groups')
          .doc(widget.groupId)
          .collection('chats')
          .add({
        'message': '$name leaved this group !',
        'type': 'notify',
        'time': FieldValue.serverTimestamp(),
      });
      for (int i = 0; i < membersList.length; i++) {
        if (membersList[i]['uid'] == uid) membersList.removeAt(i);
      }
      await _firestore.collection('groups').doc(widget.groupId).update({
        'members': membersList,
      });
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => GroupsScreen()),
          (route) => false);
    } else {
      showSnackBar(context, 'You are Admin ! You can not leave group');
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMembers();
  }

  void getAllMembers() async {
    await _firestore.collection('groups').doc(widget.groupId).get().then(
      (value) {
        setState(() {
          membersList = value['members'];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          heightGap(14),
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(18)),
              child: Icon(
                Icons.groups,
                size: 180,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              '${membersList.length} Members',
              style: TextStyle(fontSize: 18),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMembers(
                    groupName: widget.groupName,
                    groupId: widget.groupId,
                    membersList: membersList,
                  ),
                ),
              );
            },
            leading: const Icon(
              Icons.add,
              color: Colors.green,
            ),
            title: const Text(
              'Add Members',
              style: TextStyle(color: Colors.green),
            ),
          ),
          Flexible(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: membersList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Remove ${membersList[index]['name']} '),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No')),
                              ElevatedButton(
                                  onPressed: () {
                                    removeMember(index).then(
                                      (value) {
                                        if (value) {
                                          showSnackBar(context,
                                              '${membersList[index]['name']}Removed Successfully');
                                        }
                                      },
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes')),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  leading: Icon(Icons.person),
                  title: Text(membersList[index]['name']),
                  subtitle: Text(membersList[index]['email']),
                  trailing: Text(
                    membersList[index]['isAdmin'] ? 'Admin' : '',
                    style: TextStyle(color: Colors.green),
                  ),
                );
              },
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('Leaving ${widget.groupName} Group'),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('No'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            leaveUser();
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: const Text(
              'Leave Group',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
