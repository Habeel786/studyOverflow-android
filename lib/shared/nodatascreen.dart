import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget nothingToShow(String text,String imagepath){
  return Scaffold(
    body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Image(
                image: AssetImage(imagepath),
                height: 280,
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(text,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),),
              ),
            )
          ],
        )
    ),
  );
}