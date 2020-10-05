import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  Function onTap;
  String text;
  List<Color> colors;

  GradientButton({this.onTap, this.text, this.colors});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Color(0xffD76EF5), Color(0xff8F7AFE)])),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0),
          ),
        ),
      ),
    );
  }
}
