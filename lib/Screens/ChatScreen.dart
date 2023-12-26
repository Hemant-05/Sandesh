import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Custom_item/ShowImageScreen.dart';
import 'package:sandesh/Screens/OtherUserProfile.dart';
import 'package:sandesh/utils/Colors.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chattingId;

  const ChatScreen(
      {super.key, required this.userMap, required this.chattingId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msg = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;
  bool isSelected = false;

  Future getImages() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 30).then(
      (value) {
        if (value != null) {
          imageFile = File(value.path);
          uploadImage();
        }
      },
    );
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;
    DateTime now = DateTime.now();

    await _firestore
        .collection('chatroom')
        .doc(widget.chattingId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendBy': _auth.currentUser?.email,
      'message': '',
      'type': 'img',
      'time': '$now',
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chattingId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _firestore
          .collection('chatroom')
          .doc(widget.chattingId)
          .collection('chats')
          .doc(fileName)
          .update({
        'message': imageUrl,
      });
    }
  }

  void onSendMessage(String message) async {
    var date = DateTime.now();
    Map<String, dynamic> mesMap = {
      'sendBy': _auth.currentUser?.email,
      'message': message,
      'type': 'text',
      'time': '${date}',
    };
    await _firestore
        .collection('chatroom')
        .doc(widget.chattingId)
        .collection('chats')
        .add(mesMap);
    _msg.clear();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          myAppBar(context, size),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                if (snapshot.data != null) {
                  return SingleChildScrollView(
                    reverse: true,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var map = snapshot.data!.docs[index];
                        var time = map['time'].toString();
                        var st = time.substring(11, 16);
                        return map['type'] == 'text'
                            ? InkWell(
                                onLongPress: () {
                                  setState(() {
                                    // onDeleteMessage(time);
                                  });
                                },
                                child: Container(
                                  alignment:
                                      map['sendBy'] == _auth.currentUser?.email
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  width: size.width,
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: size.height * .5,
                                        minWidth: 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: map['sendBy'] ==
                                              _auth.currentUser?.email
                                          ? color2
                                          : Colors.grey,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    margin: EdgeInsets.all(2),
                                    child: Column(
                                      children: [
                                        SelectableText(
                                          map['message'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '$st',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: size.width * .25,
                                height: size.height * .2,
                                alignment:
                                    map['sendBy'] == _auth.currentUser?.email
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    var tag = map['message'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => showImageScreen(
                                          url: map['message'],
                                          tag: '$tag',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    alignment: Alignment.center,
                                    width: size.width * .25,
                                    height: size.height * .2,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.black, width: 1),
                                    ),
                                    child: map['message'] != ''
                                        ? Hero(
                                            tag: '${map['message']}',
                                            child: Image.network(
                                              map['message'],
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const CircularProgressIndicator(),
                                  ),
                                ),
                              );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
              stream: _firestore
                  .collection('chatroom')
                  .doc(widget.chattingId)
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(),
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
                      suffixIcon: IconButton(
                        onPressed: () => getImages(),
                        icon: Icon(Icons.photo),
                      ),
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
                widthGap(4),
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
    );
  }

  Widget myAppBar(BuildContext context, Size size) {
    return Container(
      height: size.height * .11,
      decoration: BoxDecoration(
        color: color2,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset('assets/images/back.svg'),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: size.width * .5
              ),
              child: StreamBuilder<DocumentSnapshot<Object?>>(
                stream: _firestore
                    .collection('users')
                    .doc(widget.userMap['uid'])
                    .snapshots(),
                builder: (context, snapshot) {
                  String st = snapshot.data?['status'];
                  Color col = color1;
                  String name = st == 'Logged Out'
                      ? 'Not Available'
                      : widget.userMap['name'];
                  if (st != 'Online') col = Colors.grey;
                  return Text(
                    '$name',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: col, fontSize: 26, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtherUserProfileScreen(map: widget.userMap),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: userPhoto(
                    context, '${widget.userMap['photo']}', size * .18, false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}