import 'package:flutter/material.dart';
import 'package:sandesh/utils/Colors.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(duration: const Duration(seconds: 2), content: Text(text)));
}

Widget heightGap(double x) {
  return SizedBox(height: x);
}

Widget widthGap(double x) {
  return SizedBox(
    width: x,
  );
}

Widget cusBoldText(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(fontSize: size, color: color, fontWeight: FontWeight.bold),
  );
}

Widget cusTextField(String label, TextEditingController controller) {
  return Container(
    constraints: const BoxConstraints(maxWidth: 400),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        label: Text(
          label,
          style: TextStyle(color: Colors.black45),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    ),
  );
}

Widget customButton(fun(), String text, double size) {
  return ElevatedButton(
    onPressed: fun,
    style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 45, vertical: 5)),
        backgroundColor: MaterialStatePropertyAll(Colors.black)),
    child: Text(
      '$text',
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.white, fontSize: size),
    ),
  );
}

Widget customProfileListTile(Icon icon, String text) {
  return ListTile(
    leading: icon,
    title: Text(
      text,
      style:
          TextStyle(color: color1, fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
}

Widget userPhoto(
    BuildContext context, String photoUrl, Size size, bool isLoading) {
  var hi = size.height;
  var wi = size.width;
  if (photoUrl != '') {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size.height * .03),
      child: SizedBox(
        height: hi * .25,
        width: wi * .5,
        child: isLoading
            ? CircularProgressIndicator()
            : Image.network(
                '$photoUrl',
                fit: BoxFit.fill,
                loadingBuilder: (context, child, loadingProgress) {
                  if(loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null?
                      loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes! : null,
                    ),
                  );
                },
          errorBuilder: (context, error, stackTrace) {
            return Center(child: Text('😢',style: TextStyle(fontSize: wi * .4),));
          },
              ),
      ),
    );
  } else {
    return Container(
      height: hi * .25,
      width: wi * .5,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(wi * .08),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Icon(
        Icons.person,
        size: hi * .2,
      ),
    );
  }
}
