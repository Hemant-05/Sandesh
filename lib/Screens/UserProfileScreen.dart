import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Custom_item/ShowImageScreen.dart';
import 'package:sandesh/Firebase_Services/Firebase_authMethod.dart';
import 'package:sandesh/Screens/EditUserDetails.dart';
import 'package:sandesh/utils/Colors.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({required this.userData, super.key});

  Map<String, dynamic> userData;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          myAppBar(context, size),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => showImageScreen(
                      tag: '${widget.userData['photo']}',
                      url: widget.userData['photo']),
                ),
              );
            },
            child: Hero(
              tag: '${widget.userData['photo']}',
              child: userPhoto(
                  context, '${widget.userData['photo']}', size, false),
            ),
          ),
          bottomBar(context, size)
        ],
      ),
    );
  }

  Widget myAppBar(BuildContext context, Size size) {
    return Container(
      height: size.height * .11,
      decoration: BoxDecoration(
        color: color2,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(22), bottomRight: Radius.circular(22)),
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
            SizedBox(
              width: size.width * .6,
              child: Text(
                '${widget.userData['name']}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color1, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: SvgPicture.asset('assets/images/log_out.svg'),
                onTap: () async {
                  // set status to logged out
                  await _firestore
                      .collection('users')
                      .doc(widget.userData['uid'])
                      .update({'status': 'Logged Out'});
                  FirebaseAuthMethods(_auth).logOut(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomBar(BuildContext context, Size size) {
    return Container(
      width: size.width,
      height: size.height * .6,
      decoration: BoxDecoration(
        color: color2,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: cusBoldText('${widget.userData['name']}', color1, 28),
                trailing: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: color1,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditUserDetails(userMap: widget.userData),
                      ),
                    );
                  },
                ),
              ),
              customProfileListTile(
                  Icon(
                    Icons.email_outlined,
                    color: color1,
                  ),
                  '${widget.userData['email']}'),
              customProfileListTile(
                  Icon(
                    Icons.call,
                    color: color1,
                  ),
                  '${widget.userData['number']}'),
              customProfileListTile(
                  Icon(
                    Icons.info_outline_rounded,
                    color: color1,
                  ),
                  '${widget.userData['about']}'),
            ],
          ),
        ),
      ),
    );
  }
}
