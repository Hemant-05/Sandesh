import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Group_Works/Create_Group/AddMembersInGroup.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group name'),
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
              '28 Members',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Flexible(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 15,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text('user $index'),
                  trailing: Icon(Icons.cancel,color: Colors.red,),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text(
              'Leave Group',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
