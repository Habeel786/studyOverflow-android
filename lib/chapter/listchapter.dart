import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/screens/allQuestions/showdata.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
class ChapterList extends StatefulWidget {
  final String stream;
  final String semester;
  final String subjectName;
  ChapterList({this.stream, this.semester, this.subjectName});
  @override
  _ChapterListState createState() => _ChapterListState();

}

class _ChapterListState extends State<ChapterList> {

  @override
  Widget build(BuildContext context) {
    int colorindex=0;
    List gradientcolors=[
      [Color(0xff6DC8F3), Color(0xff73A1F9)],
      [Color(0xffFFB157), Color(0xffFFA057)],
      [Color(0xffFF5B95), Color(0xffF8556D)],
      [Color(0xffD76EF5), Color(0xff8F7AFE)],
      [Color(0xff42E695), Color(0xff3BB2B8)],
    ];
    return StreamBuilder(
      stream: DatabaseServices().getChapterNames(widget.subjectName),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          ChapterNames chapterNames = snapshot.data;
          List names=chapterNames.chapternames;
          return Scaffold(
            body: names.isEmpty?nothingToShow("            No data present",'assets/notfound.png'):
            ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) {
                if(index%5==0){
                  colorindex=0;
                }else{
                  colorindex++;
                }
                return ChapterTile(chapterName: names[index],subject: widget.subjectName,semester: widget.semester,stream: widget.stream,colors: gradientcolors[colorindex],);
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
  ChapterTile({this.chapterName,this.subject,this.semester,this.stream,this.colors});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Demo(semester: semester,stream: stream,subject:subject,chapter: chapterName,))),
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
                    width: 250,
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
