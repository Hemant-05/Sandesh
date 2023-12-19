import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chattingId;

  ChatScreen({super.key, required this.userMap, required this.chattingId});

  final TextEditingController _msg = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? imageFile;

  Future getImages() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        imageFile = File(value.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(chattingId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendBy': _auth.currentUser?.displayName,
      'message': ' ',
      'type': 'img',
      'time': FieldValue.serverTimestamp(),
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(chattingId)
          .collection('chats')
          .doc(fileName)
          .delete();
      status = 0;
    });
    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _firestore
          .collection('chatroom')
          .doc(chattingId)
          .collection('chats')
          .doc(fileName)
          .update({
        'message': imageUrl,
      });
    }
  }

  void onSendMessage(String message) async {
    Map<String, dynamic> mesMap = {
      'sendBy': _auth.currentUser?.displayName,
      'message': message,
      'type': 'text',
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
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection('users').doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  children: [
                    Text(userMap['name']),
                    Text(snapshot.data?['status'],
                        style: TextStyle(fontSize: 12))
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
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
                        var map = snapshot.data!.docs[index];
                        return map['type'] == 'text'
                            ? Container(
                                alignment: map['sendBy'] ==
                                        _auth.currentUser?.displayName
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                width: size.width,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: map['sendBy'] ==
                                            _auth.currentUser?.displayName
                                        ? Colors.blue
                                        : Colors.grey,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  margin: EdgeInsets.all(3),
                                  child: SelectableText(
                                    map['message'],
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(
                                width: size.width * .25,
                                height: size.height * .2,
                                alignment: map['sendBy'] ==
                                        _auth.currentUser?.displayName
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
                                        borderRadius:
                                            BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    child: map['message'] != ' '
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
                    );
                  } else {
                    return Container();
                  }
                },
                stream: _firestore
                    .collection('chatroom')
                    .doc(chattingId)
                    .collection('chats')
                    .orderBy('time', descending: false)
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
}

class showImageScreen extends StatelessWidget {
  String url;
  String tag;
  showImageScreen({super.key,required this.tag,required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        alignment: Alignment.center,
        child: Hero(
          tag: '$tag',
          child: Image.network(
            url,
          ),
        ),
      ),
    );
  }
}
