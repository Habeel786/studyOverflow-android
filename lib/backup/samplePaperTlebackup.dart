//import 'package:flutter/cupertino.dart';
//import "package:flutter/material.dart";
//import 'package:provider/provider.dart';
//import 'package:studyoverflow/models/user.dart';
//import 'package:studyoverflow/screens/home/tabbarview.dart';
//import 'package:studyoverflow/shared/constants.dart';
//import 'package:studyoverflow/shared/loading.dart';
//
//class Home extends StatefulWidget {
//  @override
//  _HomeState createState() => _HomeState();
//}
//
//class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//  //FSBStatus drawerStatus;
//  Size aspectratio;
//  var divider=1.0;
//  var heightforsmalldevices=1.0;
//  TabController tabController;
//  int currentIndex = 0;
//  bool loading=false;
//  @override
//  initState(){
//    // TODO: implement initState
//    tabController = TabController(vsync: this, length: 2);
//    super.initState();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//
//    var height = MediaQuery
//        .of(context)
//        .size
//        .height;
//    var width = MediaQuery
//        .of(context)
//        .size
//        .width;
//    final userData=Provider.of<UserData>(context);
//    bool isPortrait;
//    if (MediaQuery
//        .of(context)
//        .orientation == Orientation.portrait) {
//      isPortrait = true;
//    } else {
//      isPortrait = false;
//    }
//    return userData!=null?Scaffold(
//        appBar: AppBar(
//          title: Visibility(
//              visible: !isPortrait,
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: [
//                  AppIcon(),
//                  SizedBox(
//                    width: 5.0,
//                  ),
//                  Text(
//                    'Study Overflow',
//                    style: TextStyle(
//                      fontSize: 17,
//                      fontWeight: FontWeight.w500,
//                      color: Colors.grey,
//                      fontFamily: 'Montserrat',
//                      letterSpacing: 1,
//                    ),
//                  ),
//                ],
//              )
//          ),
//          leading: IconButton(icon: Icon(Icons.menu),
//              onPressed: () => Scaffold.of(context).openDrawer()),
//          backgroundColor: Color(0xFF2d3447),
//          elevation: 0.0,
//        ),
//        body: SingleChildScrollView(
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Column(
//              children: [
//                Visibility(
//                  visible: isPortrait,
//                  child: Container(
//                    alignment: Alignment.centerLeft,
//                    height: height * 0.15,
//                    child: Text(
//                      'Study Overflow',
//                      style: TextStyle(
//                        fontSize: 27,
//                        fontWeight: FontWeight.w500,
//                        color: Colors.grey,
//                        fontFamily: 'Montserrat',
//                        letterSpacing: 1,
//                      ),
//                    ),
//                  ),
//                ),
//                Container(
//                  height: height * 0.55,
//                  width: width,
//                  child: SubjectList(semester: userData.semester,
//                    stream: userData.stream,),
//                ),
//              ],
//            ),
//          ),
//        )
//    ):Loading();
//  }
//}






//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:studyoverflow/chapter/listchapter.dart';
//import 'package:studyoverflow/models/descmodel.dart';
//import 'package:studyoverflow/screens/notes/showNotes.dart';
//import 'package:studyoverflow/services/database.dart';
//import 'package:studyoverflow/shared/constants.dart';
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
//
//    return StreamBuilder(
//        stream: DatabaseServices().getThumbnail(widget.stream, widget.semester),
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            SubjectThumbnail subjectThumbnail = snapshot.data;
//            List images = subjectThumbnail.thumbnail.values.toList();
//            List names = subjectThumbnail.thumbnail.keys.toList();
//            return Scaffold(
//              resizeToAvoidBottomPadding: false,
//              body: ListView.builder(
//                itemCount: names.length, //widget.userData.length,
//                scrollDirection: Axis.horizontal,
//                itemBuilder: (context, index) {
//                  if (index % 7 == 0) {
//                    colorindex = 0;
//                  } else {
//                    colorindex++;
//                  }
//                  return getSubjectCardPortrait(
//                      images[index], names[index], index + 1,
//                      widget.semester, widget.stream,
//                      gradientcolors[colorindex]
//                  );
//                },
//              ),
//            );
//          } else {
//            return Container();
//          }
//        }
//    );
//  }
//
//  getSubjectCardPortrait(String imgpath, String subname, int index,
//      String semester, String stream, List colors) {
//    bool isPortrait;
//    var offsetWidth;
//    var offsetContainerWidth;
//    if (MediaQuery
//        .of(context)
//        .orientation == Orientation.portrait) {
//      isPortrait = true;
//      offsetWidth = 0.7;
//      offsetContainerWidth = 0.3;
//    } else {
//      isPortrait = false;
//      offsetWidth = 0.35;
//      offsetContainerWidth = 0.15;
//    }
//    var height = MediaQuery
//        .of(context)
//        .size
//        .height;
//    var width = MediaQuery
//        .of(context)
//        .size
//        .width;
//
//    var boxHeight = height * 0.55;
//    var boxWidth = width * offsetWidth;
//
//    return Padding(
//      padding: const EdgeInsets.only(right: 10),
//      child: ClipRRect(
//        borderRadius: BorderRadius.circular(20.0),
//        child: Container(
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
//          width: width * offsetWidth,
//
//          child: Padding(
//            padding: const EdgeInsets.all(10),
//            child: Column(
//              children: [
//                Align(
//                  alignment: Alignment.topRight,
//                  child: Text(
//                    index.toString(),
//                    style: TextStyle(
//                        fontSize: 17.0,
//                        color: Colors.white
//                    ),
//                  ),
//                ),
//                Visibility(
//                  visible: isPortrait,
//                  child: SizedBox(
//                    height: height * 0.02,
//                  ),
//                ),
//                Container(
//                    width: height * 0.24,
//                    height: height * 0.24,
//                    child: imgpath != null ? CachedNetworkImage(
//                      imageUrl: imgpath,
//                      fit: BoxFit.cover,
//                      progressIndicatorBuilder: (context, url,
//                          downloadProgress) =>
//                          CircularProgressIndicator(
//                              value: downloadProgress.progress),
//                      errorWidget: (context, url, error) =>
//                          Icon(Icons.error),
//                    ) : Image(
//                      image: AssetImage('assets/fancycolored.png'),
//                      fit: BoxFit.cover,)
//                ),
//                Container(
//                  alignment: Alignment.bottomLeft,
//                  height: boxHeight * offsetContainerWidth,
//                  child: Text(subname,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 25.0,
//                          fontFamily: "SF-Pro-Text-Regular")),
//                ),
//                SizedBox(height: 8.0,),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    roundButton(
//                          () {
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) =>
//                                ChapterList(semester: semester,
//                                  stream: stream,
//                                  subjectName: subname,
//                                  imageURL: imgpath,
//                                )
//                        )
//                        );
//                      },
//                      'Get Questions',
//                      Colors.blue,
//                    ),
//
//                    roundButton(
//                          () {
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (context) =>
//                                ShowNotes(
//                                  stream: stream,
//                                  semester: semester,
//                                  subject: subname,
//                                  image: imgpath,
//                                )
//                        )
//                        );
//                      },
//                      'Get Notes',
//                      Colors.purple,
//
//                    )
//                  ],
//                ),
//              ],
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//
//  Widget roundButton(Function onTap, String text, Color color) {
//    return GestureDetector(
//      onTap: onTap,
//      child: Container(
//        padding: EdgeInsets.symmetric(
//            horizontal: 10.0, vertical: 6.0),
//        decoration: BoxDecoration(
//            color: color,
//            borderRadius: BorderRadius.circular(
//                20.0)),
//        child: Text(text,
//            style: TextStyle(
//              color: Colors.white,
//            )),
//      ),
//    );
//  }
//}

