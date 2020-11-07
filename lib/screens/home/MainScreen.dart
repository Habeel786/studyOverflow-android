import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/screens/notifications/showNotifications.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/myContribution/myContribution.dart';
import 'package:studyoverflow/preference/setstream.dart';
import 'package:studyoverflow/screens/home/home.dart';
import 'package:studyoverflow/widgets/drawerwidget.dart';
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
    final tabs = [
      Home(),
      ShowNotifications(),
      MyContributions(),
      SetStream(),
    ];
    return StreamProvider.value(
      value: DatabaseServices(uid: user.uid).userData,
      child:  Scaffold(
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
          child: DrawerWidget(),
        ),
      ),
    );
  }
}
