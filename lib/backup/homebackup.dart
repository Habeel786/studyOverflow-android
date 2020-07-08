//import 'package:flutter/cupertino.dart';
//import "package:flutter/material.dart";
//import 'package:provider/provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:studyoverflow/database.dart';
//import 'package:studyoverflow/models/descmodel.dart';
//import 'package:studyoverflow/models/user.dart';
//import 'package:studyoverflow/screens/home/tabbarview.dart';
//import 'package:studyoverflow/shared/loading.dart';
//
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
//  TabController tabController;
//  int currentIndex = 0;
//  SharedPreferences sharedPrefs;
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
//    aspectratio = MediaQuery.of(context).size;
//    if(aspectratio.toString()=='Size(360.0, 592.0)'){
//      divider=0.5;
//    }
//    final user = Provider.of<User>(context);
//    return StreamBuilder<UserData>(
//      stream:DatabaseServices(uid: user.uid).userData,
//      builder: (context, snapshot){
//        if(snapshot.hasData){
//          UserData userData = snapshot.data;
//          print(userData.stream);
//          print(userData.semester);
//          return StreamProvider<List<Data>>.value(
//            value: DatabaseServices().dataAboutQues(userData.stream, userData.semester),//userData.stream, userData.semester),
//            child: Scaffold(
//              body: ListView(
//                children: <Widget>[
//                  SizedBox(height: 15,),
//                  //hamburger Icon
//                  Container(
//                    width: MediaQuery.of(context).size.width,
//                    child: Row(
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.menu),
//                          onPressed: () async{
//                            Scaffold.of(context).openDrawer();
//                          },
//                        )
//                      ],
//                    ),
//                  ),
//                  // Study overFlow Text
//                  Padding(
//                    padding: const EdgeInsets.only(left: 15.0,top: 30.0),
//                    child: Text('Study OverFlow',
//                      style: TextStyle(
//                          fontFamily: 'Montserrat',
//                          fontSize: 30,
//                          fontWeight: FontWeight.w500
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(top:40.0),
//                    child: Container(
//                      alignment: Alignment.center,
//                      height: MediaQuery.of(context).size.height-100.0,
//                      child: SubjectList(semester: userData.semester,stream: userData.stream,),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          );
//        }else{
//          return Loading();
//        }
//      },
//    );
//  }
//}
/////////////////////----------tab bar view---------////////////////////

//import 'package:auto_size_text/auto_size_text.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:responsive_container/responsive_container.dart';
//import 'package:studyoverflow/chapter/listchapter.dart';
//import 'package:studyoverflow/database.dart';
//import 'package:studyoverflow/models/descmodel.dart';
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
//  double multiplier=1.0;
//  double divider=1.0;
//  var results;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    aspectratio = MediaQuery.of(context).size;
//    if(aspectratio.toString()=='Size(480.0, 938.7)'){
//      multiplier=3.0;
//    }if(aspectratio.toString()=='Size(360.0, 592.0)'){
//      divider=0.5;
//    }
//    print('aspect ratio=${aspectratio.toString()}');
//    return StreamBuilder(
//        stream: DatabaseServices().getThumbnail(widget.stream, widget.semester),
//        builder: (context, snapshot) {
//          if(snapshot.hasData){
//            SubjectThumbnail subjectThumbnail = snapshot.data;
//            List images=subjectThumbnail.thumbnail.values.toList();
//            List names=subjectThumbnail.thumbnail.keys.toList();
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
//                      itemCount: names.length,//widget.userData.length,
//                      controller: scrollController,
//                      scrollDirection: Axis.horizontal,
//                      itemBuilder: (context,index){
//                        return getSubjectCard(images[index],names[index] , index+1 ,widget.semester,widget.stream);//userdata[index].subject
//                      },
//                    ),
//                  ),
//                ],
//              ),
//            );
//          }else{
//            return Container();
//          }
//
//        }
//    );
//  }
//
//  getSubjectCard(String imgpath, String subname , int index,String semester, String stream){
//
//    return Stack(
//      children: <Widget>[
//        ResponsiveContainer(
//          //padding: EdgeInsets.only(right: 10),
//          heightPercent:67,
//          widthPercent: 70,
//          child: Padding(
//            padding: const EdgeInsets.only(top: 30,left: 10, right: 10),
//            child: Container(
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.circular(20),
//                  gradient: LinearGradient(
//                      colors: [
//                        Color.fromRGBO(255, 65, 108, 1.0),
//                        Color.fromRGBO(255, 75, 73, 1.0),
//                      ]
//                  )
//              ),
//              height: 250,
//              width: 225,
//              child: Column(
//                children: <Widget>[
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: <Widget>[
//                      Column(
//                        children: <Widget>[
//                          SizedBox(height: 10,),
//                          Text(
//                            index.toString(),
//                            style: TextStyle(
//                              fontSize: 20,
//                              fontFamily: "Montserrat",
//                              fontWeight: FontWeight.w200,
//                              color: Colors.white,
//
//                            ),
//                          )
//                        ],
//                      ),
//                      SizedBox(width: 10,)
//                    ],
//                  ),
//                  Container(
//                    width: 160*divider,
//                    height: 160*divider,
//                    decoration: BoxDecoration(
//                      color: Colors.transparent,
//                      borderRadius: BorderRadius.circular(100),
//                    ),
//
//                    //color: Colors.white,
//                    child: imgpath!=null?Image.network(imgpath,fit: BoxFit.cover,):Image(image: AssetImage('assets/fancycolored.png'),fit: BoxFit.cover,),
//                  ),
//                  Row(
//                    children: <Widget>[
//                      SizedBox(width: 25,),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          SizedBox(height: 30,),
//                          SizedBox(
//                            width: 200,
//                            height: 50,
//                            child: AutoSizeText(
//                              subname,
//                              style: TextStyle(
//                                fontSize: 25,
//                                fontFamily: "Montserrat",
//                                fontWeight: FontWeight.w600,
//                                color: Colors.white,
//                              ),
//                              maxLines: 2,
//                            ),
//                          ),
//
//                        ],
//                      ),
//
//                    ],
//                  ),
//                  Container(
//                    padding: EdgeInsets.only(top: 40*multiplier),
//                    child: OutlineButton(onPressed: (){
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChapterList(semester: semester,stream: stream,subjectName: subname,)));
//                    },
//                      child: Text("Get Questions",
//                        style: TextStyle(color: Colors.white),),
//                      borderSide: BorderSide(width: 2,
//                          color: Colors.white),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//
//      ],
//    );
//  }
//
//}
