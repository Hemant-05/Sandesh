import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Group_Works/GroupInfoScreen.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController gChatController = TextEditingController();
  String currentUN = "Hemant";
  List<Map<String, dynamic>> chatList = [
    {
      'message': 'Hemant created this group',
      'type': 'notify',
    },
    {'message': 'Hallu \n kya kar rahe ho', 'sendBy': 'Hemant', 'type': 'text'},
    {'message': 'Hay \n kya kar rahe ho', 'sendBy': 'Saloni', 'type': 'text'},
    {'message': 'Hiiiii \n kya kar rahe ho', 'sendBy': 'Vivek', 'type': 'text'},
    {
      'message': 'Hello \nbro kya kar rahe ho',
      'sendBy': 'Sourabh',
      'type': 'text'
    },
    {
      'message': 'hello \nkya kar rahe ho',
      'sendBy': 'shresthi',
      'type': 'text'
    },
    {'message': 'Hemant add Sarita', 'type': 'notify'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Group hall',
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupInfoScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert))
          ],
          backgroundColor: Colors.blue),
      body: Column(
        children: [
          Expanded(child: messageBuilder(chatList)),
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
                    String gChat = gChatController.value.text;
                  },
                  icon: Transform.rotate(
                    angle: 5.4,
                    child: Icon(
                      Icons.send_rounded,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageBuilder(List<Map<String, dynamic>> chatList) {
    return Container(
      child: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> map = chatList[index];
          if (map['type'] == 'text') {
            return Container(
              alignment: map['sendBy'] == currentUN
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
                      '${map['sendBy']}',
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
              alignment: map['sendBy'] == currentUN
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
                      '${map['sendBy']}',
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
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    map['message'],
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
