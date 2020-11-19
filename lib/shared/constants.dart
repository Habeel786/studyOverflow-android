import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:studyoverflow/drawerScreens/termsAndConditions.dart';
const textInputDecoration=InputDecoration(
  focusColor: Colors.pink,
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 2.0)),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF2d3447), width: 2.0)),
);

bool globalDownloading = false;

String getInitials(String name) {
  String initials;
  if (name.contains(" ")) {
    var wordLists = name.split(" ");
    initials = wordLists[0].substring(0, 1).toUpperCase() +
        wordLists[1].substring(0, 1).toLowerCase();
  } else {
    initials = name[0];
  }
  return initials;
}

const List gradientcolors=[
  [Color(0xff6DC8F3), Color(0xff73A1F9)],
  [Color(0xffFFB157), Color(0xffFFA057)],
  [Color(0xffFF5B95), Color(0xffF8556D)],
  [Color(0xffD76EF5), Color(0xff8F7AFE)],
  [Color(0xff42E695), Color(0xff3BB2B8)],
];
const TandC=
    'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app.'
    ' You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way.'
    ' You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions.'
    ' The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Habeel Hashmi.'
    'Habeel Hashmi is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.'
    'The study overflow app stores and processes personal data that you have provided to us, in order to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the study overflow app won’t work properly or at all.'
    'The app does use third party services that declare their own Terms and Conditions.'
    'Link to Terms and Conditions of third party service providers used by the app'
    'Google Play Services'
    'AdMob'
    'Google Analytics for Firebase'
    'Firebase Crashlytics'
    'If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.'
    'Along the same lines, Habeel Hashmi cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Habeel Hashmi cannot accept responsibility.'
    'With respect to Habeel Hashmi’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Habeel Hashmi accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.'
    'At some point, we may wish to update the app. The app is currently available on Android & iOS – the requirements for both systems(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Habeel Hashmi does not promise that it will always update the app so that it is relevant to you and/or works with the Android & iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.'
    'I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.'
    'If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at habeelhashmi786@gmail.com.'
;

Widget AppIcon(){
  return SizedBox(
      height: 30,
      width: 30,
      child: Image.asset("assets/fancycolored.png")
  );
}

Future<bool> ConfirmationDialogue(context,String title,String content) async {
  bool isConfirm = false;
  await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2d3447),
          title: Text(title, style: TextStyle(color: Colors.grey),),
          content: Text(
              content, style: TextStyle(color: Colors.grey)),
          actions: [
            FlatButton(onPressed: () {
              isConfirm = false;
              Navigator.pop(context);
            }, child: Text('No')),
            FlatButton(onPressed: () async {
              isConfirm = true;
              Navigator.pop(context);
            }, child: Text('Yes')),
          ],
        );
      }
  );
  return isConfirm;
}

Widget loaders(){
  return Center(
      child: Container(
          height: 50,
          width: 50,
          child: CircularProgressIndicator()
      )
  );
}

Widget tandCText(context) {
  return RichText(
    text: TextSpan(
        children: [
          TextSpan(
              text: "By continuing, you agree to study Overflow's ",
              style: TextStyle(
                  color: Colors.grey[600]
              )
          ),
          TextSpan(
              text: "terms and conditions",
              style: TextStyle(
                  color: Colors.blue
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TermsAndConditions()));
                }
          ),
        ]
    ),
  );
}