//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:studyoverflow/models/user.dart';
//import 'package:studyoverflow/services/database.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:admob_flutter/admob_flutter.dart';
//class Description extends StatefulWidget {
//  final String question;
//  final String answer;
//  final String chapter;
//  final String diagram;
//  final String yearofrepeat;
//  final String marks;
//  final String postedBy;
//  final dynamic postedOn;
//  final int like;
//  final int dislike;
//  final String keys;
//  final String semester;
//  final String course;
//
//  Description({this.question,
//    this.answer,
//    this.chapter,
//    this.diagram,
//    this.yearofrepeat,
//    this.marks,
//    this.postedBy,
//    this.postedOn,
//    this.like,
//    this.dislike,
//    this.semester,
//    this.keys,
//    this.course,
//  });
//  var banner;
//
//
//  @override
//  _DescriptionState createState() => _DescriptionState();
//}
//class _DescriptionState extends State<Description> {
//  bool isLiked=false;
//  bool isDisliked=false;
//  increment(int count,bool operation){
//    operation?DatabaseServices().updateLikes(count+1, widget.keys,widget.course):
//    DatabaseServices().updateDisLikes(count+1, widget.keys, widget.course);
//  }
//  decrement(int count,bool operation){
//    operation?DatabaseServices().updateLikes(count-1, widget.keys,widget.course):
//    DatabaseServices().updateDisLikes(count-1, widget.keys, widget.course);
//  }
//  var banner;
//  getImageText(String text){
//    List wordLists =text.split(" ");
//    String imageText=wordLists[0].substring(0,1).toUpperCase()+wordLists[1].substring(0,1).toLowerCase();
//    return imageText;
//  }
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
//    banner =  AdmobBanner(
//        adUnitId: "ca-app-pub-9118153038397153/1410457549",
//        adSize: AdmobBannerSize.FULL_BANNER);
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(elevation: 0,
//        backgroundColor: Color(0xffD76EF5),
//      ),
//      body: Container(
//        height: MediaQuery.of(context).size.height,
//        width: MediaQuery.of(context).size.width,
//        child: SingleChildScrollView(
//          physics: AlwaysScrollableScrollPhysics(),
//          child: Padding(
//            padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text('Marks:${widget.marks??""}',
//                      style: TextStyle(
//                          fontSize: 15,
//                          color: Colors.green
//                      ),
//                    ),
//                    Text(widget.yearofrepeat??"",
//                      style: TextStyle(
//                          fontSize: 15,
//                          color: Colors.lightBlueAccent
//                      ),
//                    ),
//
//                  ],
//                ),
//                SizedBox(height: 10,),
//
//                Text(widget.question,
//                  style: TextStyle(
//                      fontSize: 22,
//                      color: Colors.grey[400]
//                  ),
//                ),
//                Container(
//                  alignment: Alignment.center,
//                  child: widget.diagram==''?Container():enableUpload(),
//                ),
//                SizedBox(height: 20,),
//                Text(widget.answer,
//                  style: TextStyle(
//                      fontSize: 16,
//                      color: Colors.grey[400]
//                  ),
//                ),
//                SizedBox(height: 20,),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: [
//                    Row(
//                      children: <Widget>[
//                        StreamBuilder(
//                          stream:FirebaseDatabase.instance.reference().child('test').child(widget.course)
//                              .child(widget.keys).child('Like').onValue,
//                          builder: (context,AsyncSnapshot<Event> snapshot){
//                            if(snapshot.connectionState==ConnectionState.waiting){
//                              return Column(
//                                children: [
//                                  InkWell(
//                                    onTap: (){
//                                      //setLike();
//                                      isLiked==false?increment(widget.like,true):decrement(widget.like,true);
//                                      setState(() {
//                                        isLiked=!isLiked;
//                                      });
//                                    },
//                                    child: Icon(
//                                      Icons.sentiment_satisfied,
//                                      color: isLiked?Colors.blue:Colors.grey,
//                                    ),
//
//                                  ),
//                                  Text(
//                                    widget.like.toString(),
//                                    style: TextStyle(
//                                        color: Colors.blue
//                                    ),
//                                  )
//                                ],
//                              );
//                            }else{
//                              int like=snapshot.data.snapshot.value;
//                              print("like=$like");
//                              return Column(
//                                children: [
//                                  InkWell(
//                                    onTap: (){
//                                      //setLike();
//                                      isLiked==false?increment(like,true):decrement(like,true);
//                                      setState(() {
//                                        isLiked=!isLiked;
//                                      });
//                                    },
//                                    child: Icon(
//                                      Icons.sentiment_satisfied,
//                                      color: isLiked?Colors.blue:Colors.grey,
//                                    ),
//
//                                  ),
//                                  Text(
//                                    like.toString(),
//                                    style: TextStyle(
//                                        color: Colors.blue
//                                    ),
//                                  )
//                                ],
//                              );
//                            }
//                          },
//                        ),
//                        SizedBox(width: 20,),
//                        StreamBuilder(
//                          stream:FirebaseDatabase.instance.reference().child('test').child(widget.course)
//                              .child(widget.keys).child('DisLike').onValue,
//                          builder: (context,AsyncSnapshot<Event> snapshot){
//                            if(snapshot.connectionState==ConnectionState.waiting){
//                              return Column(
//                                children: [
//                                  InkWell(
//                                    onTap: (){
//                                      //setLike();
//                                      isLiked==false?increment(widget.dislike,false):decrement(widget.dislike,false);
//                                      setState(() {
//                                        isDisliked=!isDisliked;
//                                      });
//                                    },
//                                    child: Icon(
//                                      Icons.sentiment_dissatisfied,
//                                      color: isDisliked?Colors.red:Colors.grey,
//                                    ),
//
//                                  ),
//                                  Text(
//                                    widget.dislike.toString(),
//                                    style: TextStyle(
//                                        color: Colors.blue
//                                    ),
//                                  )
//                                ],
//                              );
//                            }else{
//                              int dislike=snapshot.data.snapshot.value;
//                              return Column(
//                                children: [
//                                  InkWell(
//                                    onTap: (){
//                                      //setLike();
//                                      isDisliked==false?increment(dislike,false):decrement(dislike,false);
//                                      setState(() {
//                                        isDisliked=!isDisliked;
//                                      });
//                                    },
//                                    child: Icon(
//                                      Icons.sentiment_dissatisfied,
//                                      color: isDisliked?Colors.red:Colors.grey,
//                                    ),
//
//                                  ),
//                                  Text(
//                                    dislike.toString(),
//                                    style: TextStyle(
//                                        color: Colors.blue
//                                    ),
//                                  )
//                                ],
//                              );
//                            }
//                          },
//                        ),
//                      ],
//                    ),
//                    SizedBox(height: 10,),
//                    widget.postedBy!=''?StreamBuilder(
//                        stream: DatabaseServices(uid: widget.postedBy).userData,
//                        builder: (context, snapshot) {
//                          UserData userData = snapshot.data;
//
//                          return userData!=null?Row(
//                            children: <Widget>[
//                              userData.profilepic==null||userData.profilepic==''?
//                              CircleAvatar(
//                                backgroundColor: Color(0xffD76EF5),
//                                child: Text(
//                                  getImageText(userData.name),
//                                  style: TextStyle(
//                                      color: Colors.white,
//                                      fontFamily: 'Montserrat',
//                                      fontSize: 20,
//                                      fontWeight: FontWeight.w500
//                                  ),
//                                ),
//                              ):Container(
//                                height:40,
//                                width:40,
//                                child: ClipRRect(
//                                  borderRadius: BorderRadius.circular(50),
//                                  child: CachedNetworkImage(
//                                    imageUrl: userData.profilepic,
//                                    fit: BoxFit.cover,
//                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
//                                        CircularProgressIndicator(value: downloadProgress.progress),
//                                  ),
//                                ),
//                              ),
//                              SizedBox(
//                                width: 10,
//                              ),
//                              Align(
//                                child: widget.postedBy!=''&&widget.postedBy!=null?
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: [
//                                    Text('Posted by: ${userData.name}',style: TextStyle(
//                                        fontSize: 13,
//                                        fontFamily: 'Montserrat',
//                                        color: Colors.amber)),
//                                    Text('on: ${widget.postedOn.toString().substring(0,19)}',style: TextStyle(
//                                        fontSize: 10,
//                                        fontFamily: 'Montserrat',
//                                        color: Colors.amber)),
//                                  ],
//                                ) :Container(),
//                              ),
//                            ],
//                          ):Container();
//                        }
//                    ):Container(),
//
//
//                  ],
//                ),
//                SizedBox(height: 20,),
//                //AD_HERE
//                Align(
//                  alignment: Alignment.center,
//                  child:banner,
//                ),
//                SizedBox(height: 20,),
//                Align(
//                  alignment: Alignment.bottomRight,
//                  child: Text(
//                    widget.keys,
//                    style: TextStyle(fontSize: 8),
//                  ),
//                )
//              ],
//            ),
//          ),
//
//        ),
//      ),
//    );
//  }
//  Widget enableUpload(){
//    return Padding(
//      padding: const EdgeInsets.only(top:50,bottom: 30),
//      child: Container(
//        child: Column(
//          children: <Widget>[
//            InteractiveViewer(
//              child: CachedNetworkImage(
//
//                imageUrl: widget.diagram,
//                fit: BoxFit.cover,
//                progressIndicatorBuilder: (context, url, downloadProgress) =>
//                    CircularProgressIndicator(value: downloadProgress.progress),
//                errorWidget: (context, url, error) => Icon(Icons.error),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
