import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/chapter/listchapter.dart';
import 'package:studyoverflow/screens/notes/showNotes.dart';

class NotesAndQuestions extends StatefulWidget {
  String subjectname;
  String semester;
  String stream;
  String imageURL;


  NotesAndQuestions({this.subjectname,this.stream,this.semester,this.imageURL});

  @override
  _NotesAndQuestionsState createState() => _NotesAndQuestionsState();
}

class _NotesAndQuestionsState extends State<NotesAndQuestions> with AutomaticKeepAliveClientMixin {



 @override
 bool get wantKeepAlive => true;
 Widget _currentAd = SizedBox(
   height: 0,
   width: 0,
 );
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentAd= FacebookNativeAd(
//        placementId: "IMG_16_9_APP_INSTALL#410376460331794_410964320273008",
//        bannerSize: BannerSize.MEDIUM_RECTANGLE,
        adType: NativeAdType.NATIVE_BANNER_AD,
        bannerAdSize: NativeBannerAdSize.HEIGHT_50,
        placementId: "410376460331794_411236640245776",
        keepAlive: true,
        listener: (result,value){
          print('BannerAd$result-->$value');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF2d3447),
          title: Text(widget.subjectname),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Notes And Sample Papers',),
              Tab(text: 'Questions And Topics',)
            ],
          ),
        ),
         body: Column(
           children: [
             Expanded(
               child: TabBarView(
                 children: [
                   ShowNotes(
                     stream: widget.stream,
                     semester: widget.semester,
                     subject: widget.subjectname,
                   ), ChapterList(semester: widget.semester,
                     stream: widget.stream,
                     subjectName: widget.subjectname,
                     imageURL: widget.imageURL,
                   )

                 ],
               ),
             ),
             Container(
                 height: 50.0,
                 child: _currentAd
             )
           ],
         ),
      ),
    );
  }
}
