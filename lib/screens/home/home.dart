import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/home/tabbarview.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //FSBStatus drawerStatus;
  Size aspectratio;
  var divider=1.0;
  var heightforsmalldevices=1.0;
  TabController tabController;
  int currentIndex = 0;
  SharedPreferences sharedPrefs;
  bool loading=false;
  @override
  initState(){
    // TODO: implement initState
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream:DatabaseServices(uid: user.uid).userData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          print(userData.stream);
          print(userData.semester);
          bool isPortrait;
          if (MediaQuery
              .of(context)
              .orientation == Orientation.portrait) {
            isPortrait = true;
          } else {
            isPortrait = false;
          }
          return Scaffold(
              appBar: AppBar(
                title: Visibility(
                    visible: !isPortrait,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppIcon(),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'StudyOverflow',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    )
                ),
                leading: IconButton(icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer()),
                backgroundColor: Color(0xFF2d3447),
                elevation: 0.0,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isPortrait,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: height * 0.15,
                          child: Text(
                            'StudyOverflow',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontFamily: 'Montserrat',
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: height * 0.55,
                        width: width,
                        child: SubjectList(semester: userData.semester,
                          stream: userData.stream,),
                      ),
                    ],
                  ),
                ),
              )
          );
        }else{
          return Loading();
        }
      },
    );
  }
}