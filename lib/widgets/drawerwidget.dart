import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:studyoverflow/drawerScreens/sendfeedback.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/screens/important_links/importantLinks.dart';
import 'package:studyoverflow/screens/wrapper.dart';
import 'package:studyoverflow/services/auth.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final user = Provider.of<User>(context);
    return Drawer(
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
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (_)=>ImpLinks()));
                  },
                  leading: Icon(Icons.link,color: Colors.grey,),
                  title: Text(
                      'Important Links'
                      ,style: TextStyle(color: Colors.grey)
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  onTap: ()async {
                    final InAppReview inAppReview = InAppReview.instance;

                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }

                  },
                  leading: Icon(Icons.star_border,color: Colors.grey,),
                  title: Text("Rate This App",style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(
                  height: 5,
                ),
//                ListTile(
//                  onTap: () {
//                    Navigator.pop(context);
//                    Navigator.push(context,MaterialPageRoute(builder: (_)=>AboutDev()));
//                  },
//                  leading: Icon(Icons.info_outline,color: Colors.grey,),
//                  title: Text("About Developer And App",style: TextStyle(color: Colors.grey)),
//                ),
//                SizedBox(
//                  height: 5,
//                ),
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
    );
  }
}
