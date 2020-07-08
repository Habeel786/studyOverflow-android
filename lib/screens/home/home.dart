import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/home/tabbarview.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/services/database.dart';


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
    aspectratio = MediaQuery.of(context).size;
    if(aspectratio.toString()=='Size(360.0, 592.0)'){
      divider=0.5;
      heightforsmalldevices=0.0;
    }
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream:DatabaseServices(uid: user.uid).userData,
      builder: (context, snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          print(userData.stream);
          print(userData.semester);
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(icon: Icon(Icons.menu), onPressed: ()=>Scaffold.of(context).openDrawer()),
                backgroundColor: Color(0xFF2d3447),
                elevation: 0.0,
              ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10.0),
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
                     SizedBox(
                       height: 30*heightforsmalldevices,
                     ),

                     Container(
                       height: 600,
                        child: SubjectList(semester: userData.semester,stream: userData.stream,)
                  ),
                ],
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