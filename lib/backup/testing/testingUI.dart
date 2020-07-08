import 'package:flutter/material.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'data.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  final String semester;
  final String stream;
  HomeScreen({this.semester, this.stream});
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _HomeScreenState extends State<HomeScreen> {
  var  currentPage = images.length - 1.0;
  var currentsubject;

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return StreamBuilder(
      stream:  DatabaseServices().getThumbnail('computer engineering', '6'),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          SubjectThumbnail subjectThumbnail = snapshot.data;
          List myimages=subjectThumbnail.thumbnail.values.toList();
          List mynames=subjectThumbnail.thumbnail.keys.toList();


          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xFF1b1e44),
                      Color(0xFF2d3447),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    tileMode: TileMode.clamp)),
            child: Scaffold(
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top:60.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: IconButton(icon: Icon(Icons.menu,color: Colors.white,size: 30,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:20,top:20,bottom:50),
                        child: Text(
                          'StudyOverflow',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            letterSpacing: 3
                          ),

                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          CardScrollWidget(currentPage,myimages,mynames),
                          Positioned.fill(
                            child: PageView.builder(
                              itemCount: mynames.length,
                              controller: controller,
                              reverse: true,
                              itemBuilder: (context, index) {
                                return Container();
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }else{
          return Loading();
        }
      }
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;
  List myimages;
  List mynames;

  CardScrollWidget(this.currentPage,this.myimages,this.mynames);

  @override
  Widget build(BuildContext context) {
   // Key mykey;
    List gradientcolors=[
      [Color(0xff6DC8F3), Color(0xff73A1F9)],
      [Color(0xffFFB157), Color(0xffFFA057)],
      [Color(0xffFF5B95), Color(0xffF8556D)],
      [Color(0xffD76EF5), Color(0xff8F7AFE)],
      [Color(0xff42E695), Color(0xff3BB2B8)],
    ];
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {

        var mywidth = contraints.maxWidth;
        var myheight = contraints.maxHeight;

        var safeWidth = mywidth - 2 * padding;
        var safeHeight = myheight - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < mynames.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              onTap: (){print('tapped');},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: gradientcolors[i],
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
                        //Image.asset(images[i], fit: BoxFit.cover),
                        Align(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text((mynames.length-i).toString(),style: TextStyle(color: Colors.white,fontSize: 20),),
                          ),
                          alignment: Alignment.topRight,
                        ),
                         Align(
                           alignment: Alignment.center,
                           child: Padding(
                             padding: const EdgeInsets.only(bottom:170.0),
                             child: Container(
                                 width:200,
                                 height: 200,
                                 //decoration: BoxDecoration(color: Colors.white),
                                 child: myimages[i]!=null?Image.network(myimages[i],fit: BoxFit.cover,):Image(image:AssetImage('assets/fancycolored.png'),height: 160,width: 60,)
                             ),
                           ),
                         ),

                        GestureDetector(
                          onTap: (){print("tapped");},
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(mynames[i],
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
//                                    child: RaisedButton(
//                                      child: Text('Get Questions'),
//                                      onPressed: (){print("button pressed");},
//                                    ),

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
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          key: UniqueKey(),
          children: cardList,
        );
      }),
    );
  }
}
