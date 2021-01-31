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
  Widget _currentAd = SizedBox(
    height: 0,
    width: 0,
  );
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final tabs = [
      Home(),
      ShowNotifications(),
      MyContributions(),
      SetStream(),
    ];
    return //updateApp?UpdateScreen():
    StreamProvider.value(
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

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:studyoverflow/models/user.dart';
// import 'package:studyoverflow/screens/drawer/drawer.dart';
// import 'package:studyoverflow/screens/home/home.dart';
// import 'package:studyoverflow/services/database.dart';
// import 'package:studyoverflow/shared/constants.dart';
//
//
// class MainScreen extends StatelessWidget {
//   final String profilePic;
//   MainScreen({this.profilePic});
//
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<User>(context);
//     return Scaffold(
//       body: StreamProvider.value(
//         value: DatabaseServices(uid: user.uid).userData,
//         child: Stack(
//           children: [
//             DrawerScreen(),
//             HomePage()
//           ],
//         ),
//       ),
//
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//
//   double xOffset = 0;
//   double yOffset = 0;
//   double scaleFactor = 1;
//   bool isDrawerOpen = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //_specializationData = SpecializationController().getSpecializationFromApi();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     String swipeDirection;
//     return GestureDetector(
//       onPanUpdate: (details) {
//         swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
//       },
//       onPanEnd: (details) {
//         if (swipeDirection == 'left') {
//           //handle swipe left event
//           setState(() {
//             isDrawerOpen= false;
//             scaleFactor=1;
//             yOffset=0;
//             xOffset = 0;
//           });
//         }
//         if (swipeDirection == 'right') {
//           //handle swipe right event
//           setState(() {
//             isDrawerOpen= true;
//             scaleFactor=0.6;
//             yOffset=150;
//             xOffset = 230;
//           });
//         }
//       },
//
//       onTap: (){
//         setState(() {
//           isDrawerOpen= false;
//           scaleFactor=1;
//           yOffset=0;
//           xOffset = 0;
//         });
//       },
//       child: AnimatedContainer(
//         transform: Matrix4.translationValues(xOffset, yOffset, 0)
//           ..scale(scaleFactor)..rotateY(isDrawerOpen? -0.5:0),
//         duration: Duration(milliseconds: 250),
//
//         decoration: BoxDecoration(
//             color: Color(0xFF2d3447),
//
//             borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)
//
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(isDrawerOpen?40.0:0.0),
//           child: Stack(
//             children: [
//               Container(
//
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 //padding: EdgeInsets.only(left: 10, right: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SafeArea(
//                       child: Row(
//                         //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           isDrawerOpen?IconButton(
//                             icon: Icon(
//                               Icons.arrow_back_ios,
//                               color: Colors.white,
//                             ),
//                             onPressed: (){
//                               setState(() {
//                                 isDrawerOpen= false;
//                                 scaleFactor=1;
//                                 yOffset=0;
//                                 xOffset = 0;
//                               });
//                             },
//
//                           ): IconButton(
//                               icon: Icon(Icons.menu,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   isDrawerOpen= true;
//                                   scaleFactor=0.6;
//                                   yOffset=150;
//                                   xOffset = 230;
//                                 });
//                               }),
//                           AppIcon(),
//                           SizedBox(width: 20.0,),
//                           Text(
//                             'Study Overflow',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey,
//                               fontFamily: 'Montserrat',
//                               letterSpacing: 1,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(child: Home())
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }
// }
