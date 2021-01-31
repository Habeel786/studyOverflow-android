import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/notificationModel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/home/tabbarview.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  //FSBStatus drawerStatus;
  Size aspectratio;
  var divider=1.0;
  var heightforsmalldevices=1.0;
  TabController tabController;
  int currentIndex = 0;
  bool loading=false;
  Widget _currentAd = SizedBox(
    height: 0,
    width: 0,
  );
  @override
  bool get wantKeepAlive => true;
  @override
  initState(){
    // TODO: implement initState
    tabController = TabController(vsync: this, length: 2);
    setState(() {
      _currentAd= FacebookBannerAd(
//        placementId: "IMG_16_9_APP_INSTALL#410376460331794_410964320273008",
//        bannerSize: BannerSize.MEDIUM_RECTANGLE,
        placementId: "410376460331794_410624736973633",
        bannerSize: BannerSize.STANDARD,
        keepAlive: true,
        listener: (result,value){
          print('BannerAd$result-->$value');
        },
      );
    }
    );
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    var height = MediaQuery
        .of(context)
        .size
        .height;
    final userData=Provider.of<UserData>(context);

    return userData!=null?Scaffold(
        // appBar: AppBar(
        //   title: Row(
        //     children: [
        //       AppIcon(),
        //       SizedBox(
        //         width: 5.0,
        //       ),
        //       Text(
        //         'Study Overflow',
        //         style: TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.w500,
        //           color: Colors.grey,
        //           fontFamily: 'Montserrat',
        //           letterSpacing: 1,
        //         ),
        //       ),
        //     ],
        //   ),
        //   // leading: IconButton(icon: Icon(Icons.menu),
        //   //     onPressed: () => Scaffold.of(context).openDrawer()),
        //    backgroundColor: Color(0xFF2d3447),
        //   elevation: 0.0,
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal:5.0),
          child: StreamBuilder(
            stream: DatabaseServices().getSubjects(userData.stream),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                SubjectsModel allSubjects= snapshot.data;
                List subjects = allSubjects.subjects;
                return  Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                       // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true, // <- added
                        primary: false,
                        itemCount: subjects.length,
                        itemBuilder: (context,index){
                          return SubjectList(subjects: subjects[index],semester: (index+1).toString(),);
                        },
                      ),
                    ),
                    _currentAd,
                  ],
                );
              }else{
                return Container();
              }
            }
          ),
        )
    ):Loading();
  }
}