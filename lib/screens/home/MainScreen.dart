import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:studyoverflow/screens/home/selectsubject.dart';
import 'package:studyoverflow/drawerScreens/aboutDevScreen.dart';
import 'package:studyoverflow/screens/notifications/showNotifications.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/drawerScreens/sendfeedback.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/myContribution.dart';
import 'package:studyoverflow/preference/setstream.dart';
import 'package:studyoverflow/screens/home/home.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import '../wrapper.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex=0;
  var _pagecontroller=PageController();
  String imageText;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream:DatabaseServices(uid: user.uid).userData ,
      builder:(context,snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          final tabs = [
            Home(),
            ShowNotifications(),
            //SelectStrSem(),
//            Description(course: '',
//            keys: '',
//            semester: '',
//            dislike: 0,
//            like: 0,
//            postedOn: 'datehabeelhashmi78612345',
//            postedBy: 'm3ViUcbWnmV0qZwOrmfQa3zUmAu2',
//            chapter: '',
//            diagram: '',
//            answer: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
//            marks: '4',
//            question: 'What is Lorem Ipsum?',
//            yearofrepeat: '2019,2018,2017',),
            MyContributions(finalStream: userData.stream,),
            SetStream(),
          ];

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
                  icon: Icon(Icons.notification_important),
                  title: Text('Notifications'),
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
                              currentAccountPicture: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: userData.profilepic == null ||
                                    userData.profilepic == '' ?
                                Container(
                                  color: Color(0xFF2d3447),
                                  alignment: Alignment.center,
                                  child: Text(
                                    getInitials(userData.name),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ) : CachedNetworkImage(
                                  imageUrl: userData.profilepic,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url,
                                      downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                                ),
                              ),
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
                                Share.share(
                                    "Study Overflow contains latest Questions and Notes, you can also share yours by uploading them, download now "
                                        'https://play.google.com/store/apps/details?id=com.habeel.studyoverflow');
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
                              onTap: ()async {
                                await launch('https://play.google.com/store/apps/details?id=com.habeel.studyoverflow');
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
                                Navigator.pop(context);
                                showAboutDialog(
                                  context: context,
                                  applicationVersion: '1.0.2',
                                  applicationLegalese: TandC,
                                  applicationName: 'Study Overflow',
                                );
                              },
                              leading: Icon(Icons.receipt,color: Colors.grey,),
                              title: Text("Terms And Condition",style: TextStyle(color: Colors.grey)
                              ),
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
                                bool isLogout=await ConfirmationDialogue(context,'Logout','Logout From Study Overflow?');
                                if(isLogout){
                                  AuthService().signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Wrapper()));
                                }else{
                                  Navigator.of(context).pop();
                                }
                              },
                              leading: Icon(Icons.exit_to_app,color: Colors.grey,),
                              title: Text("Log Out",style: TextStyle(color: Colors.grey),),
                            ),
                          ],
                        ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(userData.uid.toString(),
                          style: TextStyle(
                              fontSize: 10
                          ),
                        ),
                      ),
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
