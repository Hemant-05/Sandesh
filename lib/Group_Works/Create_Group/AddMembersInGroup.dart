import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandesh/Group_Works/Create_Group/CreateNewGroup.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  final TextEditingController searchUserCon = TextEditingController();
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  getCurrentUserDetails() async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .get()
          .then(
        (map) {
          setState(() {
            membersList.add({
              'name': map['name'],
              'email': map['email'],
              'uid': map['uid'],
              'isAdmin': true,
            });
          });
          print(map);
        },
      );
    } catch (e) {
      print(e);
    }
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
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap?['uid']) isAlreadyExist = true;
    }
    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          'name': userMap?['name'],
          'email': userMap?['email'],
          'uid': userMap?['uid'],
          'isAdmin': false,
        });
        userMap = null;
      });
    } else {
      showSnackBar(context, '${userMap?['name']} Already Added !');
    }
  }

  void onRemoveResult(int i) async {
    if (membersList[i]['uid'] != _auth.currentUser?.uid) {
      setState(() {
        membersList.removeAt(i);
      });
    } else {
      showSnackBar(context, 'You can not Remove yourself');
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
              controller: searchUserCon,
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
                String search = searchUserCon.value.text;
                onSearch(search);
                searchUserCon.clear();
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
                    trailing: IconButton(
                      onPressed: () => onRemoveResult(index),
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateNewGroup(
                      membersList: membersList,
                    ),
                  ),
                );
              },
              child: Icon(Icons.done),
            )
          : Container(),
    );
  }
}
