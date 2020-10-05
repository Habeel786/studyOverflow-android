//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:studyoverflow/screens/notes/showNotes.dart';
//import 'package:studyoverflow/services/database.dart';
//import 'package:responsive_container/responsive_container.dart';
//import 'package:studyoverflow/chapter/listchapter.dart';
//import 'package:studyoverflow/models/descmodel.dart';
//import 'package:studyoverflow/shared/constants.dart';
//import 'package:studyoverflow/shared/nodatascreen.dart';
//class SubjectList extends StatefulWidget {
//  final String semester;
//  final String stream;
//  SubjectList({this.semester, this.stream});
//
//  @override
//  _SubjectListState createState() => _SubjectListState();
//}
//
//class _SubjectListState extends State<SubjectList> {
//  ScrollController scrollController;
//  Size aspectratio;
//
//  //double multiplier=1.0;
//  double offset = 1.0;
//  double imageoffset = 1.0;
//  var results;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    int colorindex = 0;
//    aspectratio = MediaQuery
//        .of(context)
//        .size;
//    if (aspectratio.toString() == 'Size(480.0, 938.7)') {
//      offset = 1.2;
//    }
//    if (aspectratio.toString() == 'Size(360.0, 592.0)') {
//      offset = 0.9;
//      imageoffset = 0.7;
//    }
//    print('aspect ratio=${aspectratio.toString()}');
//    return StreamBuilder(
//        stream: DatabaseServices().getThumbnail(widget.stream, widget.semester),
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            SubjectThumbnail subjectThumbnail = snapshot.data;
//            List images = subjectThumbnail.thumbnail.values.toList();
//            List names = subjectThumbnail.thumbnail.keys.toList();
//            return Scaffold(
//              resizeToAvoidBottomPadding: false,
//              body: ListView(
//                children: <Widget>[
//                  ResponsiveContainer(
//                    //bug for small devices and tablets
//                    heightPercent: 60.0,
//                    widthPercent: 50.0,
//                    //bug for small devices and tablets
//                    child: ListView.builder(
//                      itemCount: names.length, //widget.userData.length,
//                      scrollDirection: Axis.horizontal,
//                      itemBuilder: (context, index) {
//                        if (index % 7 == 0) {
//                          colorindex = 0;
//                        } else {
//                          colorindex++;
//                        }
//                        return getSubjectCardPortrait(
//                            images[index], names[index], index + 1,
//                            widget.semester, widget.stream,
//                            gradientcolors[colorindex]); //userdata[index].subject
//                      },
//                    ),
//                  ),
//                ],
//              ),
//            );
//          } else {
//            return Container();
//          }
//        }
//    );
//  }
//
//  getSubjectCardPortrait(String imgpath, String subname, int index, String semester,
//      String stream, List colors) {
//    var cardAspectRatio = 2 / 3;
//
//    bool isLandScape;
//    var orientationSizeOffset;
//    var orientationTextOffset;
//    if(MediaQuery.of(context).orientation==Orientation.landscape){
//      orientationSizeOffset=0.5;
//      orientationTextOffset=0.7;
//      isLandScape=true;
//    }else{
//      orientationSizeOffset=1.0;
//      orientationTextOffset=1.0;
//      isLandScape=false;
//    }
//    return Padding(
//      padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
//      child: ClipRRect(
//        borderRadius: BorderRadius.circular(16.0),
//        child: Container(
//          height: 450,
//          width: 270 * offset,
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                colors: colors,
//              ),
//              boxShadow: [
//                BoxShadow(
//                    color: Colors.black12,
//                    offset: Offset(3.0, 6.0),
//                    blurRadius: 10.0)
//              ]),
//          child: AspectRatio(
//            aspectRatio: cardAspectRatio,
//            child: Stack(
//              fit: StackFit.expand,
//              children: <Widget>[
//                Align(
//                  child: Padding(
//                    padding: const EdgeInsets.all(15),
//                    child: Text((index).toString(), style: TextStyle(
//                        color: Colors.white, fontSize: 20),),
//                  ),
//                  alignment: Alignment.topRight,
//                ),
//                Align(
//                  alignment: Alignment.center,
//                  child: Padding(
//                    padding: isLandScape?EdgeInsets.only(bottom: 80):EdgeInsets.only(bottom: 160.0),
//                    child: Container(
//                        width: (180*orientationSizeOffset) * imageoffset,
//                        height: (180*orientationSizeOffset) * imageoffset,
//                        //decoration: BoxDecoration(color: Colors.white),
//                        child: imgpath != null ? CachedNetworkImage(
//                          imageUrl: imgpath,
//                          fit: BoxFit.cover,
//                          progressIndicatorBuilder: (context, url,
//                              downloadProgress) =>
//                              CircularProgressIndicator(
//                                  value: downloadProgress.progress),
//                          errorWidget: (context, url, error) =>
//                              Icon(Icons.error),
//                        ) : Image(
//                          image: AssetImage('assets/fancycolored.png'),
//                          fit: BoxFit.cover,)
//                    ),
//                  ),
//                ),
//
//                Align(
//                  alignment: Alignment.bottomLeft,
//                  child: Column(
//                    mainAxisSize: MainAxisSize.min,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: 16.0, vertical: 8.0),
//                        child: Text(subname,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 25.0 * orientationTextOffset,
//                                fontFamily: "SF-Pro-Text-Regular")),
//                      ),
//                      SizedBox(
//                        height: 10.0,
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.only(bottom: 12.0),
////
//
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: [
//                            GestureDetector(
//                              onTap: () =>
//                                  Navigator.push(context, MaterialPageRoute(
//                                      builder: (context) =>
//                                          ChapterList(semester: semester,
//                                            stream: stream,
//                                            subjectName: subname,
//                                            imageURL: imgpath,
//                                          ))),
//                              child: Container(
//                                padding: EdgeInsets.symmetric(
//                                    horizontal: 22.0, vertical: 6.0),
//                                decoration: BoxDecoration(
//                                    color: Colors.blueAccent,
//                                    borderRadius: BorderRadius.circular(
//                                        20.0)),
//                                child: Text("Get Questions",
//                                    style: TextStyle(color: Colors.white)),
//                              ),
//                            ),
//                            GestureDetector(
//                              onTap: () =>
//                                  Navigator.push(context, MaterialPageRoute(
//                                      builder: (context) =>
//                                      //nothingToShow("No notes available for this subject",'assets/notfound.png')
//                                      ShowNotes(
//                                        stream: stream,
//                                        semester: semester,
//                                        subject: subname,
//                                        image: imgpath,
//                                      )
//                                  )
//                                  ),
//                              child: Container(
//                                padding: EdgeInsets.symmetric(
//                                    horizontal: 10.0, vertical: 6.0),
//                                decoration: BoxDecoration(
//                                    color: Colors.deepPurpleAccent,
//                                    borderRadius: BorderRadius.circular(
//                                        20.0)),
//                                child: Text("Get Notes",
//                                    style: TextStyle(
//                                      color: Colors.white,
//
//                                    )),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ],
//                  ),
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}
