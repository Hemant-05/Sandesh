import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Screens/HomeScreen.dart';
import 'package:sandesh/utils/Colors.dart';
import 'package:uuid/uuid.dart';

class EditUserDetails extends StatefulWidget {
  EditUserDetails({required this.userMap,super.key});
  Map<String, dynamic> userMap;

  @override
  State<EditUserDetails> createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController about_con = TextEditingController();
  TextEditingController number_con = TextEditingController();
  TextEditingController name_con = TextEditingController();
  File? profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    about_con = TextEditingController(text: '${widget.userMap['about']}');
    number_con = TextEditingController(text: '${widget.userMap['number']}');
    name_con = TextEditingController(text: '${widget.userMap['name']}');
  }
  void update() async {
    String about = about_con.text;
    String number = number_con.text;
    String name = name_con.text;
    await _firestore
        .collection('users')
        .doc(widget.userMap?['uid'])
        .update({'about': '$about', 'number': '$number', 'name': '$name'});
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
  }

  void updatePicture() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((x) {
      if (x != null) {
        profileImage = File(x.path);
        uploadPicture();
      }
    });
  }

  uploadPicture() async {
    String fileName = Uuid().v1();
    bool status = true;
    setState(() {
      isLoading = true;
    });
    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(profileImage!).catchError((e) {
      showSnackBar(context, 'Error accourd : $e');
      status = false;
    });
    if (status) {
      String picUrl = await uploadTask.ref.getDownloadURL();
      widget.userMap['photo'] = picUrl;
      await _firestore
          .collection('users')
          .doc(widget.userMap['uid'])
          .update({'photo': '$picUrl'});
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            myAppBar(context, size),
            ui(context, size),
            customButton(() {
              update();
            }, 'Save', 26),
            heightGap(20),
          ],
        ),
      ),
    );
  }

  Widget ui(BuildContext context, Size size) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                     updatePicture();
                     print('on Tap fun : ${widget.userMap['photo']}');
                  },
                  child: userPhoto(context, '${widget.userMap['photo']}',size,isLoading)),
              heightGap(20),
              cusTextField('Set your name', name_con),
              heightGap(18),
              cusTextField('set your bio.', about_con),
              heightGap(18),
              cusTextField('set your number.', number_con),
            ],
          ),
        ),
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
                '${widget.userMap['name']}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color1, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  icon: Icon(Icons.done, color: color1),
                  onPressed: () {
                    update();
                  },
                ),),
          ],
        ),
      ),
    );
  }
}
