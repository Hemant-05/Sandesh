import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandesh/Custom_item/Custom_widgets.dart';
import 'package:sandesh/Custom_item/ShowImageScreen.dart';
import 'package:sandesh/utils/Colors.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({required this.map,super.key});
  final Map<String, dynamic> map;

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            myAppBar(context, size),
            heightGap(20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => showImageScreen(
                        tag: '${widget.map['photo']}',
                        url: widget.map['photo']),
                  ),
                );
              },
              child: Hero(
                tag: '${widget.map['photo']}',
                child: userPhoto(
                    context, '${widget.map['photo']}', size, false),
              ),
            ),
            heightGap(20),
            bottomBar(context, size),
          ],
        ),
      ),
    );
  }
  Widget myAppBar(BuildContext context, Size size){
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
                '${widget.map['name']}',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color1, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
  Widget bottomBar(BuildContext context, Size size) {
    return Container(
      width: size.width,
      height: size.height * .5,
      decoration: BoxDecoration(
        color: color2,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: cusBoldText('${widget.map['name']}', color1, 28),
              ),
              customProfileListTile(
                  Icon(
                    Icons.email_outlined,
                    color: color1,
                  ),
                  '${widget.map['email']}'),
              customProfileListTile(
                  Icon(
                    Icons.call,
                    color: color1,
                  ),
                  '${widget.map['number']}'),
              customProfileListTile(
                  Icon(
                    Icons.info_outline_rounded,
                    color: color1,
                  ),
                  '${widget.map['about']}'),
            ],
          ),
        ),
      ),
    );
  }
}
