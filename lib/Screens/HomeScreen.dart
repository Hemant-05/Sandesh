import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
import 'package:sandesh/Group_Works/GroupsScreen.dart';
import 'package:sandesh/Screens/ChatScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
    getAllUsersList();
  }

  void getAllUsersList() async {
    var list = await _firestore.collection('users');
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

  void onSearch(String search) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore
          .collection('users')
          .where('name', isEqualTo: search)
          .get()
          .then((value) {
        setState(
          () {
            userMap = value.docs[0].data();
          },
        );
        print(userMap);
      });
    } catch (e) {
      userMap = null;
      print(e.toString());
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              setStatus('Offline');
              FirebaseAuthMethods(FirebaseAuth.instance).logOut(context);
            },
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Log Out',
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Account : \n ${_auth.currentUser?.email}',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            heightGap(20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(hintText: 'ex. user343@gmail.com'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var search = searchController.value.text;
                setState(() {
                  onSearch(search);
                });
              },
              child: Text('Search'),
            ),
            userMap != null
                ? ListTile(
                    onTap: () {
                      searchController.clear();
                      String? u1 = _auth.currentUser?.displayName;
                      String chattingId = chatId(u1!, userMap?['name']);
                      print(chattingId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                              userMap: userMap ?? {}, chattingId: chattingId),
                        ),
                      );
                    },
                    leading: Icon(Icons.person),
                    title: Text(userMap?['name']),
                    subtitle: Text(userMap?['email']),
                    trailing: Icon(Icons.message),
                  )
                : Container(),
            /*Expanded(
              child: Container(
                color: Colors.grey,
                child: StreamBuilder(
                  stream: _firestore.collection('users').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    return ListView.builder(itemBuilder: (context,index){
                      return ListTile(
                        title: Text(snapshot.data.toString()),
                      );
                    },);
                  },
                ),
              ),
            ),*/
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group),
        onPressed: (){
          Navigator.pushNamed(context, 'groups');
        },
      ),
    );
  }
}
