import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/services/admob_service.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';


class QuestionList extends StatefulWidget {
  final String subject;
  final String semester;
  final String stream;
  final String chapter;
  final String imageURL;
  final Color appBarColor;

  QuestionList({this.subject, this.semester, this.stream, this.chapter,
    this.appBarColor, this.imageURL});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  List<Data> mydata=List();
  List<Data> filteredMydata=[];
  List<Data> tempdata=[];

  bool isSearching=false;
  bool notFound=false;
  var _data;
  bool adFlag=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
    _data= FirebaseDatabase.instance.reference().child('test').child(widget.stream)
        .orderByChild('Category').equalTo(widget.stream+'-'+widget.semester+'-'+widget.subject
        +'-'+widget.chapter
    ).onValue;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _data,
          builder: (_, AsyncSnapshot<Event> snapshot) {
            if (snapshot.hasData) {
              mydata.clear();
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value ?? {};
              map.forEach((k, v) {
                mydata.add(new Data(
                  key: k,
                  chapter: v['Category'].toString().split('-')[3] ?? '',
                  answer: v['Answer'] ?? '',
                  course: v['Category'].toString().split('-')[0] ?? '',
                  question: v['Question'] ?? '',
                  semester: v['Category'].toString().split('-')[1] ?? '',
                  subject: v['Category'].toString().split('-')[2] ?? '',
                  diagram: v['Diagram'] ?? '',
                  yearofrepeat: v['YearOfRepeat'] ?? '',
                  marks: v['Marks'] ?? '',
                  thumbnail: v['Thumbnail'] ?? '',
                  postedBy: v['PostedBy'] ?? '',
                  postedOn: v['PostedOn'] ?? '',
                  dislike: v['DisLike'] ?? 0,
                  like: v['Like'] ?? 0,
                ));
              });
              filterthedata(String value) {
                setState(() {
                  tempdata = mydata.where((u) =>
                  (u.question.toLowerCase().contains(value.toLowerCase())))
                      .toList();
                }
                );
                tempdata.isEmpty ? notFound = true : notFound = false;
                print(tempdata);
              }
              if (tempdata.isEmpty) {
                filteredMydata = mydata;
              } else {
                filteredMydata = tempdata;
              }
              return mydata.isEmpty ? nothingToShow(
                  "Data is to be added", 'assets/notfound.png')
                  : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        )
                    ),
                    backgroundColor: widget.appBarColor,
                    actions: [
                      isSearching ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.white,),
                          onPressed: () {
                            setState(() {
                              isSearching = false;
                            });
                          }) : IconButton(
                          icon: Icon(Icons.search, color: Colors.white,),
                          onPressed: () {
                            setState(() {
                              isSearching = true;
                            });
                          })
                    ],
                    centerTitle: true,
                    title: !isSearching ? Text(widget.chapter) :
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          onChanged: (string) {
                            filterthedata(string);
                          },
                          style: TextStyle(
                              color: Colors.black
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                              hintText: "Search Question Here",
                              hintStyle: TextStyle(
                                  color: Colors.grey[600]
                              )
                          ),
                        ),
                      ),
                    ),
                    pinned: true,
                    expandedHeight: 200.0,
                    flexibleSpace: SafeArea(
                      child: FlexibleSpaceBar(
                        background: Align(
                            alignment: Alignment.topCenter,
                            child: widget.imageURL != null ? Container(
                              height: 200,
                              width: 200,
                              child: CachedNetworkImage(
                                imageUrl: widget.imageURL,
                                fit: BoxFit.fitHeight,
                                progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ) : Image(image: AssetImage(
                                'assets/posterImage.png'), fit: BoxFit.cover,)
                        ),
                      ),
                    ),
                  ),

                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if ((index + 1) % 11 == 0) {
                        adFlag = true;
                      } else {
                        adFlag = false;
                      }
                      return adFlag ? AdmobService().listtileWithAd(
                        index,
                        context,
                        filteredMydata[index].answer,
                        filteredMydata[index].question,
                        filteredMydata[index].chapter,
                        filteredMydata[index].diagram,
                        filteredMydata[index].yearofrepeat,
                        filteredMydata[index].marks,
                        filteredMydata[index].postedBy,
                        filteredMydata[index].postedOn,
                        filteredMydata[index].like,
                        filteredMydata[index].dislike,
                        filteredMydata[index].semester,
                        filteredMydata[index].key,
                        filteredMydata[index].course,
                      ) :
                      AdmobService().listtileWithoutAd(
                        index,
                        context,
                        filteredMydata[index].answer,
                        filteredMydata[index].question,
                        filteredMydata[index].chapter,
                        filteredMydata[index].diagram,
                        filteredMydata[index].yearofrepeat,
                        filteredMydata[index].marks,
                        filteredMydata[index].postedBy,
                        filteredMydata[index].postedOn,
                        filteredMydata[index].like,
                        filteredMydata[index].dislike,
                        filteredMydata[index].semester,
                        filteredMydata[index].key,
                        filteredMydata[index].course,
                      );
                    },
                      childCount: tempdata.isEmpty
                          ? mydata.length
                          : filteredMydata.length,
                    ),
                  )
                ],
              );
            } else {
              return Loading();
            }
          }
      ),
    );
  }
}

