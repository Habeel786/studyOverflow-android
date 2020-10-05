import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/screens/allQuestions/showdata.dart';
import 'dart:ui' as ui;
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
class ChapterList extends StatefulWidget {
  final String imageURL;
  final String stream;
  final String semester;
  final String subjectName;

  ChapterList({this.stream, this.semester, this.subjectName, this.imageURL});

  @override
  _ChapterListState createState() => _ChapterListState();

}

class _ChapterListState extends State<ChapterList> {

  @override
  Widget build(BuildContext context) {
    int colorindex=0;
    return StreamBuilder(
      stream: DatabaseServices().getChapterNames(widget.subjectName),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          ChapterNames chapterNames = snapshot.data;
          List names=chapterNames.chapternames;
          return Scaffold(
            body: names.isEmpty?nothingToShow("No data present",'assets/notfound.png'):
            ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                if(index%7==0){
                  colorindex=0;
                }else{
                  colorindex++;
                }
                return ChapterTile(chapterName: names[index],
                  subject: widget.subjectName,
                  semester: widget.semester,
                  stream: widget.stream,
                  colors: gradientcolors[colorindex],
                  imageURL: widget.imageURL,);
              },
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}



class ChapterTile extends StatelessWidget {
  String chapterName;
  String stream;
  String semester;
  String subject;
  List colors;
  String imageURL;

  ChapterTile(
      {this.chapterName, this.subject, this.semester, this.stream, this.colors, this.imageURL});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                QuestionList(
                  semester: semester,
                  stream: stream,
                  subject: subject,
                  chapter: chapterName,
                  appBarColor: colors[1],
                  imageURL: imageURL,
                )
            )
            ),
        child: Stack(
          children:<Widget>[
            Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
                    height: 120,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: Center(
                      child: AutoSizeText(
                        chapterName,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              //color: _color,
              gradient: LinearGradient(colors: colors
                  , begin: Alignment.topLeft, end: Alignment.bottomRight),

            ),
          ),
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: CustomPaint(
                size: Size(100, 150),
                painter: CustomCardShapePainter(24.0,
                    colors[0], colors[1]),
              ),
            ),
//            Container(
//              height: 170,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.circular(20),
//                //color: _color,
//                gradient: LinearGradient(colors: colors
//                    , begin: Alignment.topLeft, end: Alignment.bottomRight),
//
//              ),
//            ),
//            Positioned(
//              right: 0,
//              bottom: 0,
//              top: 0,
//              child: CustomPaint(
//                size: Size(100, 150),
//                painter: CustomCardShapePainter(24.0,
//                    colors[0], colors[1]),
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(25.0),
//              child: SizedBox(
//                height: 120,
//                width: MediaQuery.of(context).size.width*0.6,
//                child: Center(
//                  child: AutoSizeText(
//                    chapterName,
//                    style: TextStyle(
//                      fontSize: 25,
//                      color: Colors.white,
//                    ),
//                    maxLines: 3,
//                  ),
//                ),
//              ),
//            ),
          ]
        ),
      ),
    );
  }
}
class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
