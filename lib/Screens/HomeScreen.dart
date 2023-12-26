import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Custom_item/ShowImageScreen.dart';
import 'package:sandesh/Screens/ChatScreen.dart';
import 'package:sandesh/Screens/UserProfileScreen.dart';
import 'package:sandesh/utils/Colors.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({required this.currentUserData, super.key});

  Map<String, dynamic> currentUserData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> usersList = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser?.uid).update({
      'status': status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus('Online');
    } else {
      setStatus('Offline');
    }
  }

  String chatId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    }
    return '$user2$user1';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: size.height * .025,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfileScreen(userData: widget.currentUserData)));
            },
            child: myAppBar(size * .8),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isLoading ? Colors.transparent : color2,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(52),
                  topLeft: Radius.circular(52),
                ),
              ),
              child: isLoading
                  ? Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .orderBy('status', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              var map = snapshot.data?.docs[index];
                              if (map?['uid'] != _auth.currentUser?.uid) {
                                String st = map?['status'];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ListTile(
                                    onTap: () {
                                      String? u1 = _auth.currentUser?.displayName;
                                      String chattingId = chatId(
                                          u1!, map?['name']);
                                      Map<String,dynamic> temp = {
                                        'name' : map?['name'],
                                        'uid' : map?['uid'],
                                        'photo' : map?['photo'],
                                        'number' : map?['number'],
                                        'email' : map?['email'],
                                        'about' : map?['about'],
                                        'status' : map?['status'],
                                      };
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(
                                                  userMap: temp,
                                                  chattingId: chattingId),
                                        ),
                                      );
                                    },
                                    leading: InkWell(
                                      onTap: () {
                                        String pt = map?['photo'];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                showImageScreen(
                                                    tag: '$pt', url: '$pt'),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: '${map?['photo']}',
                                        child: userPhoto(context, map?['photo'],
                                            size * .2, isLoading),
                                      ),
                                    ),
                                    title: Text(
                                      map?['name'],
                                      style: TextStyle(
                                          color: color1,
                                          fontSize: st == 'Offline' ? 22 : 18),
                                    ),
                                    subtitle: Visibility(
                                      visible: st == 'Offline' ? false : true,
                                      child: Text(
                                        st,
                                        style:
                                        TextStyle(color: color1, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                );
                              }else{
                                return Container();
                              }
                            }
                          );
                        } else {
                          return Container(
                            width: size.width,
                            alignment: Alignment.center,
                            child: Text(
                              'Nothing',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: color1),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: () {
          Navigator.pushNamed(context, 'groups');
        },
      ),
    );
  }

  Widget myAppBar(Size size) {
    return Container(
      height: size.height * .26,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          userPhoto(
              context, widget.currentUserData['photo'], size * .7, isLoading),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  '${widget.currentUserData['name']}',
                  style: const TextStyle(
                      fontSize: 40,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  '${widget.currentUserData['about'] == '' ? 'Not set' : '${widget.currentUserData['about']}'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          Container(),
        ],
      ),
    );
  }
}
