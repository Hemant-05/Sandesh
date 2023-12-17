import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sandesh/Group_Works/Create_Group/CreateNewGroup.dart';
import 'package:sandesh/Group_Works/GroupChatScreen.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => GroupChatScreen()));
              },
              title: Text('Group $index'),
              leading: Icon(Icons.groups),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => CreateNewGroup(),),);
        },
        tooltip: 'Create New Group',
      ),
    );
  }
}
