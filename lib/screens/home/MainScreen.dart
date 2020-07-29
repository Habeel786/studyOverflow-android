import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/drawerScreens/aboutDevScreen.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/drawerScreens/sendfeedback.dart';
import 'package:studyoverflow/drawerScreens/termsAndConditions.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/myContribution.dart';
import 'package:studyoverflow/preference/setstream.dart';
import 'package:studyoverflow/screens/home/home.dart';
import 'package:studyoverflow/screens/home/selectsubject.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import '../wrapper.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex=0;
  var _pagecontroller=PageController();
  final tabs=[
    Home(),
    SelectStrSem(),
    MyContributions(),
    SetStream(),
  ];
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream:DatabaseServices(uid: user.uid).userData ,
      builder:(context,snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return  Scaffold(
            body:PageView(
              controller: _pagecontroller,
              children: tabs,
              onPageChanged: (index){
                setState(() {
                  currentIndex=index;
                });
              },
            ) ,
            bottomNavigationBar: BottomNavyBar(
              backgroundColor: Color(0xFF2d3447),
              selectedIndex: currentIndex,
              showElevation: false,
              itemCornerRadius: 8,
              curve: Curves.easeInBack,
              onItemSelected: (index) => setState(() {
                currentIndex = index;
                _pagecontroller.jumpToPage(currentIndex);
              }),
              items: [
                BottomNavyBarItem(
                  icon: Icon(Icons.apps),
                  title: Text('Home'),
                  activeColor: Colors.red,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.add_box),
                  title: Text('Ask'),
                  activeColor: Colors.purpleAccent,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.assignment),
                  title: Text(
                    'Contribute',
                  ),
                  activeColor: Colors.pink,
                  textAlign: TextAlign.center,
                ),
                BottomNavyBarItem(
                  icon: Icon(Icons.person),
                  title: Text('Profile'),
                  activeColor: Colors.blue,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            drawer: Theme(
        data: Theme.of(context).copyWith(
        canvasColor: Color(0xFF2d3447),
        ),
              child: Drawer(
                child: Column(
                  children: [
                    Expanded(
                        child:ListView(
                          padding: EdgeInsets.zero,
                          children: <Widget>[
                            UserAccountsDrawerHeader(
                              accountEmail: Text(
                                user.email,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              accountName: Text(
                                userData.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Color(0xffD76EF5), Color(0xff8F7AFE)]
                                  )
                              ),
                            ),
                            SizedBox(height: 20,),
                            ListTile(
                              onTap: (){
                                debugPrint("Tapped Profile");
                              },
                              leading: Icon(Icons.share,color: Colors.grey,),
                              title: Text(
                                  'Share App With Friends'
                                  ,style: TextStyle(color: Colors.grey)
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              onTap: () {
                                debugPrint("Tapped settings");
                              },
                              leading: Icon(Icons.star_border,color: Colors.grey,),
                              title: Text("Rate This App",style: TextStyle(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context,MaterialPageRoute(builder: (_)=>AboutDev()));
                              },
                              leading: Icon(Icons.info_outline,color: Colors.grey,),
                              title: Text("About Developer And App",style: TextStyle(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              onTap: () {
                                //debugPrint("Tapped Notifications");
                                Navigator.pop(context);
                                showAboutDialog(
                                  context: context,
                                  applicationVersion: '1.0.0',
                                  applicationLegalese: TandC,
                                  applicationIcon: AppIcon(),
                                  applicationName: 'StudyOverflow',
                                );
                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>TermsAndConditions()));
                              },
                              leading: Icon(Icons.receipt,color: Colors.grey,),
                              title: Text("Terms And Condition",style: TextStyle(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>SendFeedback()));
                              },
                              leading: Icon(Icons.mail_outline,color: Colors.grey,),
                              title: Text("Send FeedBack",style: TextStyle(color: Colors.grey)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              onTap: () async{
                                AuthService().signOut();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Wrapper()));
                              },
                              leading: Icon(Icons.exit_to_app,color: Colors.grey,),
                              title: Text("Log Out",style: TextStyle(color: Colors.grey),),
                            ),
                          ],
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('UID:${userData.uid}'),
                    )
                  ],
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
