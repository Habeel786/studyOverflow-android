import 'package:cached_network_image/cached_network_image.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:studyoverflow/services/admob_service.dart';
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
 final String semester;



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
   this.semester
 });

 @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final ams = AdmobService();
  double _scale = 1.0;
  double _previousScale = 1.0;
  bool isLiked=false;
  bool isDisliked=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,
        backgroundColor: Color(0xffD76EF5),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 40,left: 20,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Marks:${widget.marks??""}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green
                        ),
                      ),
                      Text(widget.yearofrepeat??"",
                        style: TextStyle(
                          fontSize: 15,
                            color: Colors.lightBlueAccent
                        ),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),

                  Text(widget.question,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[400]
                  ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: widget.diagram==''?Container():enableUpload(),
                  ),
                  SizedBox(height: 20,),
                  Text(widget.answer,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[400]
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Visibility(
                        visible: widget.like!=null&&widget.dislike!=null?true:false,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                         child: Row(
                            children: <Widget>[
                              Column(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                          Icons.sentiment_satisfied,
                                        color: isLiked?Colors.blue:Colors.grey,
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          isLiked=true;
                                          isDisliked=false;
                                        });
                                        DatabaseServices().updateLikes(widget.like+1, widget.question, widget.semester);
                                      },
                                  ),
                                  Text(
                                      widget.like.toString(),
                                    style: TextStyle(
                                      color: Colors.blue
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                        Icons.sentiment_dissatisfied,
                                      color: isDisliked?Colors.red:Colors.grey,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        isDisliked=true;
                                        isLiked=false;
                                      });
                                      DatabaseServices().updateDisLikes(widget.dislike+1, widget.question, widget.semester);
                                    },
                                  ),
                                  Text(
                                      widget.dislike.toString(),
                                    style: TextStyle(
                                        color: Colors.red
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: widget.postedBy!=''&&widget.postedBy!=null?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Posted by: ${widget.postedBy}',style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: Colors.amber)),
                            Text('on: ${widget.postedOn}',style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                                color: Colors.amber)),
                          ],
                        ) :Container(),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  //AD_HERE
                  Align(
                    alignment: Alignment.center,
                    child: AdmobBanner(
                        adUnitId: "ca-app-pub-9118153038397153/1410457549",
                        adSize: AdmobBannerSize.FULL_BANNER),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),

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
            GestureDetector(
              onScaleStart: (ScaleStartDetails details) {
                print(details);
                _previousScale = _scale;
                setState(() {});
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                print(details);
                _scale = _previousScale * details.scale;
                setState(() {});
              },
              onScaleEnd: (ScaleEndDetails details) {
                print(details);

                _previousScale = 1.0;
                setState(() {});
              },
              child: Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
                child: CachedNetworkImage(
                  imageUrl: widget.diagram,
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
