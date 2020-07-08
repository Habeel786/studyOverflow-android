import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
class SelectStrSem extends StatefulWidget {
  @override
  _SelectStrSemState createState() => _SelectStrSemState();
}

class _SelectStrSemState extends State<SelectStrSem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left:10),
              child: Image(
                image: AssetImage('assets/onboarding1.png'),
                height: 280,
              ),
            ),
            SizedBox(height: 40,),
            Center(
              child: SizedBox(
                height: 40.0,
                width: 300.0,
                child: AutoSizeText("We Are Currently Working On This Feature,"
                    "It Will Be Available Soon",
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
      ),
    );
  }
}
