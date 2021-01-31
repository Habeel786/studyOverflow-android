import 'package:cached_network_image/cached_network_image.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/widgets/likeDislike.dart';
class Description extends StatefulWidget {

  final NewData mydata;
  final List<Color> themeColor;
  Description({this.mydata,this.themeColor});



  @override
  _DescriptionState createState() => _DescriptionState();
}
class _DescriptionState extends State<Description> {
  bool isLiked=false;
  bool isDisliked=false;
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .reference().child('topics');
  var banner;

  getImageText(String text) {
    List wordLists = text.split(" ");
    String imageText = wordLists[0].substring(0, 1).toUpperCase() +
        wordLists[1].substring(0, 1).toLowerCase();
    return imageText;
  }
  Widget _currentAd = SizedBox(
    height: 0,
    width: 0,
  );
  @override
  void initState() {
    // TODO: implement initState
    _currentAd= FacebookBannerAd(
//        placementId: "IMG_16_9_APP_INSTALL#410376460331794_410964320273008",
//        bannerSize: BannerSize.MEDIUM_RECTANGLE,
      placementId: "IMG_16_9_APP_INSTALL#410376460331794_410624736973633",
      bannerSize: BannerSize.STANDARD,
      keepAlive: true,
      listener: (result,value){
        print('BannerAd$result-->$value');
      },
    );
    super.initState();
//    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
//    banner =  AdmobBanner(
//        adUnitId: "ca-app-pub-9118153038397153/1410457549",
//        adSize: AdmobBannerSize.FULL_BANNER);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.themeColor,
            )
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: ()=>Navigator.pop(context),
                    icon: Icon(
                        Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                    height: 50,
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF2d3447),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0)),
                  ),
                  child: ClipRRect(
                    borderRadius:BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0)),
                    child: ListView(
                      children: [
                        SizedBox(height: 20,),
                        Text(widget.mydata.question,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey[400]
                          ),
                        ),
                        SizedBox(height: 20,),
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.mydata.diagram.length,
                          itemBuilder: (context,index){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: 'Zoomable Image',
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: widget.mydata.diagram[index] == ''
                                        ? Container()
                                        : enableUpload(widget.mydata.diagram[index]),
                                  ),
                                ),
                                Text(widget.mydata.answer[index],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[400]
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(height: 20,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: <Widget>[
                                Like(
                                  count: widget.mydata.like,
                                  keys: widget.mydata.key,
                                  course: widget.mydata.course,
                                  isClicked: isLiked,
                                  icon: Icons.sentiment_very_satisfied,
                                  databaseReference: databaseReference,
                                  operation: 'Like',
                                  trigger: true,
                                  iconColor: Colors.grey,
                                ),
                                SizedBox(width: 10,),
                                Like(
                                  count: widget.mydata.dislike,
                                  keys: widget.mydata.key,
                                  course: widget.mydata.course,
                                  isClicked: isDisliked,
                                  icon: Icons.sentiment_very_dissatisfied,
                                  databaseReference: databaseReference,
                                  operation: 'DisLike',
                                  trigger: false,
                                  iconColor: Colors.grey,
                                ),
                                SizedBox(width: 20,),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Visibility(
                              visible: widget.mydata.postedBy != '',
                              child: StreamBuilder(
                                  stream: DatabaseServices(
                                      uid: widget.mydata.postedBy).userData,
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
                                          child: widget.mydata.postedBy != '' &&
                                              widget.mydata.postedBy != null ?
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text('Posted by: ${userData
                                                  .name}', style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.amber)),
                                              Text('on: ${widget.mydata.postedOn
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          widget.mydata.key,
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
              ),
              _currentAd
            ],
          ),
        ),
      ),
    );
  }
  Widget enableUpload(String imageurl){
    return Padding(
      padding: const EdgeInsets.only(top:20,bottom: 20),
      child: Container(
        child: Column(
          children: <Widget>[
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  imageUrl:imageurl,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
