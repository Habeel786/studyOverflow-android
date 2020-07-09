import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget nothingToShow(String text,String imagepath){
  return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left:10),
            child: Image(
              image: AssetImage(imagepath),
              height: 280,
            ),
          ),
          SizedBox(height: 40,),
          Center(
            child: SizedBox(
              height: 40.0,
              width: 300.0,
              child: AutoSizeText(text,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),),
            ),
          )
        ],
      )
  );
}