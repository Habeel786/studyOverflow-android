import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/widgets/likeDislike.dart';
class Description extends StatefulWidget {
  final String question;
  final String answer;
  final String chapter;
  final String diagram;
  final String yearofrepeat;
  final String marks;
  final String postedBy;
  final dynamic postedOn;
  final int like;
  final int dislike;
  final String keys;
  final String semester;
  final String course;

  Description({this.question,
    this.answer,
    this.chapter,
    this.diagram,
    this.yearofrepeat,
    this.marks,
    this.postedBy,
    this.postedOn,
    this.like,
    this.dislike,
    this.semester,
    this.keys,
    this.course,
  });

  var banner;


  @override
  _DescriptionState createState() => _DescriptionState();
}
class _DescriptionState extends State<Description> {
  bool isLiked=false;
  bool isDisliked=false;
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference().child('test');
  var banner;

  getImageText(String text) {
    List wordLists = text.split(" ");
    String imageText = wordLists[0].substring(0, 1).toUpperCase() +
        wordLists[1].substring(0, 1).toLowerCase();
    return imageText;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
    banner =  AdmobBanner(
        adUnitId: "ca-app-pub-9118153038397153/1410457549",
        adSize: AdmobBannerSize.FULL_BANNER);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD76EF5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              height: 50,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2d3447),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Marks:${widget.marks ?? ""}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green
                                  ),
                                ),
                                Text(widget.yearofrepeat ?? "",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: 20,),

                            Text(widget.question,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.grey[400]
                              ),
                            ),
                            Tooltip(
                              message: 'Zoomable Image',
                              child: Container(
                                alignment: Alignment.center,
                                child: widget.diagram == ''
                                    ? Container()
                                    : enableUpload(),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Text(widget.answer,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400]
                              ),
                            ),
                            SizedBox(height: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Like(
                                      count: widget.like,
                                      keys: widget.keys,
                                      course: widget.course,
                                      isClicked: isLiked,
                                      icon: Icons.sentiment_very_satisfied,
                                      databaseReference: databaseReference,
                                      operation: 'Like',
                                      trigger: true,
                                    ),
                                    SizedBox(width: 10,),
                                    Like(
                                      count: widget.dislike,
                                      keys: widget.keys,
                                      course: widget.course,
                                      isClicked: isDisliked,
                                      icon: Icons.sentiment_very_dissatisfied,
                                      databaseReference: databaseReference,
                                      operation: 'DisLike',
                                      trigger: false,
                                    ),
                                    SizedBox(width: 20,),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Visibility(
                                  visible: widget.postedBy != '',
                                  child: StreamBuilder(
                                      stream: DatabaseServices(
                                          uid: widget.postedBy).userData,
                                      builder: (context, snapshot) {
                                        UserData userData = snapshot.data;

                                        return userData != null ? Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                                backgroundColor: Color(
                                                    0xffD76EF5),
                                                child: userData.profilepic ==
                                                    null ||
                                                    userData.profilepic == '' ?
                                                Text(
                                                  getInitials(
                                                      userData.name.trimLeft()),
                                                  style: TextStyle(fontSize: 20,
                                                      color: Colors.white),
                                                ) : ClipRRect(
                                                  borderRadius: BorderRadius
                                                      .circular(50),
                                                  child: CachedNetworkImage(
                                                    imageUrl: userData
                                                        .profilepic,
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder: (
                                                        context, url,
                                                        downloadProgress) =>
                                                        CircularProgressIndicator(
                                                            value: downloadProgress
                                                                .progress),
                                                  ),

                                                )
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Align(
                                              child: widget.postedBy != '' &&
                                                  widget.postedBy != null ?
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text('Posted by: ${userData
                                                      .name}', style: TextStyle(
                                                      fontSize: 13,
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.amber)),
                                                  Text('on: ${widget.postedOn
                                                      .toString().substring(
                                                      0, 19)}',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: 'Montserrat',
                                                          color: Colors.amber)),
                                                ],
                                              ) : Container(),
                                            ),
                                          ],
                                        ) : Container();
                                      }
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            //AD_HERE
                            Align(
                              alignment: Alignment.center,
                              child: banner,
                            ),
                            SizedBox(height: 20,),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                widget.keys,
                                style: TextStyle(fontSize: 8),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget enableUpload(){
    return Padding(
      padding: const EdgeInsets.only(top:50,bottom: 30),
      child: Container(
        child: Column(
          children: <Widget>[
            InteractiveViewer(
              child: CachedNetworkImage(

                imageUrl: widget.diagram,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
