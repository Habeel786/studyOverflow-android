import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:studyoverflow/chapter/listchapter.dart';
import 'package:studyoverflow/models/descmodel.dart';
class SubjectList extends StatefulWidget {
  final String semester;
  final String stream;
  SubjectList({this.semester, this.stream});

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  ScrollController scrollController;
  Size aspectratio;
  //double multiplier=1.0;
  double offset=1.0;
  double imageoffset=1.0;
  var results;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int colorindex=0;
    List gradientcolors=[
      [Color(0xff6DC8F3), Color(0xff73A1F9)],
      [Color(0xffFFB157), Color(0xffFFA057)],
      [Color(0xffFF5B95), Color(0xffF8556D)],
      [Color(0xffD76EF5), Color(0xff8F7AFE)],
      [Color(0xff42E695), Color(0xff3BB2B8)],
      [Color(0xff56ab2f), Color(0xffa8e063)],
      [Color(0xffeb3349), Color(0xfff45c43)],
      [Color(0xff6DC8F3), Color(0xff73A1F9)],
      [Color(0xffFFB157), Color(0xffFFA057)],
      [Color(0xffFF5B95), Color(0xffF8556D)],
      [Color(0xffD76EF5), Color(0xff8F7AFE)],
      [Color(0xff42E695), Color(0xff3BB2B8)],
      [Color(0xff56ab2f), Color(0xffa8e063)],
      [Color(0xffeb3349), Color(0xfff45c43)],
    ];
    aspectratio = MediaQuery.of(context).size;
    if(aspectratio.toString()=='Size(480.0, 938.7)'){
      offset=1.2;
    }if(aspectratio.toString()=='Size(360.0, 592.0)'){
      offset=0.9;
      imageoffset=0.7;
    }
    print('aspect ratio=${aspectratio.toString()}');
    return StreamBuilder(
      stream: DatabaseServices().getThumbnail(widget.stream, widget.semester),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          SubjectThumbnail subjectThumbnail = snapshot.data;
          List images=subjectThumbnail.thumbnail.values.toList();
          List names=subjectThumbnail.thumbnail.keys.toList();
          return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: ListView(
            children: <Widget>[
              ResponsiveContainer(
                //bug for small devices and tablets
                heightPercent: 60.0,
                widthPercent: 50.0,
                //bug for small devices and tablets
                child: ListView.builder(
                  itemCount: names.length,//widget.userData.length,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    if(index%7==0){
                      colorindex=0;
                    }else{
                      colorindex++;
                    }
                    return getSubjectCard(images[index],names[index] , index+1 ,widget.semester,widget.stream,gradientcolors[colorindex]);//userdata[index].subject
                  },
                ),
              ),
            ],
          ),
        );
        }else{
          return Container();
        }

      }
    );
  }
  
  getSubjectCard(String imgpath, String subname , int index,String semester, String stream,List colors){
    var cardAspectRatio = 2 / 3;
    return Padding(
      padding: const EdgeInsets.only(top:30,left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          height: 450,
          width: 270*offset,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
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
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text((index).toString(),style: TextStyle(color: Colors.white,fontSize: 20),),
                  ),
                  alignment: Alignment.topRight,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:160.0),
                    child: Container(
                        width:180*imageoffset,
                        height: 180*imageoffset,
                        //decoration: BoxDecoration(color: Colors.white),
                        child: imgpath!=null?CachedNetworkImage(
                          imageUrl: imgpath,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ):Image(image:AssetImage('assets/fancycolored.png'),fit: BoxFit.cover,)
                    ),
                  ),
                ),

                  Align(
                  alignment: Alignment.bottomLeft,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            Padding(
                                  padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                             child: Text(subname,
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
//

                                     child: GestureDetector(
                                       onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ChapterList(semester: semester,stream: stream,subjectName: subname,))),
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
//                borderRadius: BorderRadius.circular(20),
//                gradient: LinearGradient(
//                  colors: colors
//                )
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
//                    Container(
//                      width: 160*divider,
//                      height: 160*divider,
//                      decoration: BoxDecoration(
//                        color: Colors.transparent,
////                          gradient: LinearGradient(
////                              //begin: Alignment.topCenter,
////                              colors: [
////                                Color(0xFFfdfbfb),
////                                Color(0xFFebedee),
////
////                              ]
////                          ),
//                        borderRadius: BorderRadius.circular(100),
//                      ),
//
//                      //color: Colors.white,
//                      child: imgpath!=null?Image.network(imgpath,fit: BoxFit.cover,):Image(image: AssetImage('assets/fancycolored.png'),fit: BoxFit.cover,),
////                      child: Image.asset(
////                          imgpath,
////                        fit: BoxFit.cover,
////                      ),
//                    ),
////                  Image(
////                   // fit: BoxFit.values,
////                    image:AssetImage(
////                        imgpath,
////
////                    ),
////                    height: 165.0,
////
////                  ),
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
  }

}
