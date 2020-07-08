import 'package:flutter/material.dart';
class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    var cardAspectRatio = 2 / 3;
    return Scaffold(
      body: SafeArea(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
              height: 450,
              width: 270,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffD76EF5), Color(0xff8F7AFE)],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(3.0, 6.0),
                        blurRadius: 10.0)
                  ]),
              child: AspectRatio(
                aspectRatio: cardAspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    //Image.asset(images[i], fit: BoxFit.cover),
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(('testing').toString(),style: TextStyle(color: Colors.white,fontSize: 20),),
                      ),
                      alignment: Alignment.topRight,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom:160.0),
                        child: Container(
                            width:180,
                            height: 200,
                            //decoration: BoxDecoration(color: Colors.white),
                            child:Image(image:AssetImage('assets/fancycolored.png'))
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: (){print("tapped");},
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text('test',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontFamily: "SF-Pro-Text-Regular")),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
//                                    child: RaisedButton(
//                                      child: Text('Get Questions'),
//                                      onPressed: (){print("button pressed");},
//                                    ),

                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("Get Questions",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
