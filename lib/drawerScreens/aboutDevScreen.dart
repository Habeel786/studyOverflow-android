import 'package:flutter/material.dart';
class AboutDev extends StatefulWidget {
  @override
  _AboutDevState createState() => _AboutDevState();
}

class _AboutDevState extends State<AboutDev> {
  var textstyle=TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 20,
      fontWeight: FontWeight.w500
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
          centerTitle: true,
        backgroundColor:Color(0xffD76EF5),
          elevation: 0,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('StudyOverflow v1.0',
                  style: textstyle.apply(color: Colors.grey)
                ),
                SizedBox(height: 20,),
                Text('Study Overflow is developed for backbenchers carrying inside a spark to study '
                    'apart from their "out of the box thoughts" but the '
                    'lack of resources suppresses that spark.'
                    'hence coming up with an idea of widest collection of Questions and Notes.',
                  style: TextStyle(color: Colors.grey),

                ),
                SizedBox(height: 20,),
                Text('Practial knowledge is incomparable with some digits on a paper '
                    'but still to cope up in this race we need to give essensce to that digits too.',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20,),
                Text('Made with Love ❤ and some knowledge gained outside those 4 walls 😉.',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 60,),
                Text('Developed by Habeel Hashmi an Under Graduate student',
                style: TextStyle(fontSize: 16, fontFamily: 'Montserrat',color: Colors.grey

                ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
