import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
import 'package:sandesh/Screens/ChatScreen.dart';
import 'package:sandesh/Screens/UserProfileScreen.dart';
import 'package:sandesh/utils/Colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> usersList = [];
  final TextEditingController searchController = TextEditingController();
  Map<String, dynamic>? currentUserData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
    getAllUsersList();
  }

  void getAllUsersList() async {
    await _firestore.collection('users').get().then((value) {
      setState(() {
        String? userUid = _auth.currentUser?.uid;
        for (int i = 0; i < value.size; i++) {
          userMap = value.docs[i].data();
          if (userMap?['uid'] != userUid) {
            usersList.add(userMap!);
          } else {
            currentUserData = value.docs[i].data();
          }
        }
        isLoading = false;
      });
    });
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

  Future onRefresh() async {
    setState(() {
      usersList.clear();
      getAllUsersList();
    });
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
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfileScreen(userData : currentUserData!)));
            },
            child: myAppBar(size),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                return onRefresh();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isLoading? Colors.transparent : color2,
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
                    : ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              String? u1 = _auth.currentUser?.displayName;
                              String chattingId =
                                  chatId(u1!, usersList[index]['name']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      userMap: usersList[index],
                                      chattingId: chattingId),
                                ),
                              );
                            },
                            leading: userPhoto(context, usersList[index]['photo'], size * .2, isLoading),
                            title: Text(
                              usersList[index]['name'],
                              style: TextStyle(color: color1),
                            ),
                            subtitle: Text(
                              usersList[index]['status'],
                              style: TextStyle(color: color1),
                            ),
                          );
                        },
                      ),
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
          userPhoto(context, currentUserData?['photo'] , size * .7,isLoading),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  '${_auth.currentUser?.displayName}',
                  style: const TextStyle(
                      fontSize: 40,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  '${currentUserData?['about'] == ''? 'Not set' : '${currentUserData?['about']}'}',
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
