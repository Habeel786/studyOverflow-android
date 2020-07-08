import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyoverflow/Animation/FadeAnimation.dart';
import 'file:///C:/Users/Smart%20computer/AndroidStudioProjects/studyoverflow/lib/services/database.dart';
import 'package:studyoverflow/models/user.dart';
class SendFeedback extends StatefulWidget {
  @override
  _SendFeedbackState createState() => _SendFeedbackState();
}

class _SendFeedbackState extends State<SendFeedback> {

  final _formkey = GlobalKey<FormState>();
  String email;
  String name;
  String feedback;
  String phone;

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder(
      stream: DatabaseServices(uid: user.uid).userData,
      builder: (context,snapshot){
        if(snapshot.hasData){
          UserData userData = snapshot.data;
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              title: Text('Feedback'),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor:Color(0xffD76EF5),
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left:30.0,right: 30.0,),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        FadeAnimation(0.5, Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey),
                            initialValue:user.email,
                            onChanged: (val){
                              setState(() {
                                email=val;
                              });
                            },
                            validator: (val)=>!val.contains('@gmail.com',0)?"email Must Not Valid": null,
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        ),
                        //--------------stream--------------//
                        FadeAnimation(0.5, Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey),
                            initialValue:userData.name,
                            onChanged: (val){
                              setState(() {
                                name=val;
                              });
                            },
                            validator: (val)=>val.length<6?"Name Must Not Be Empty": null,
                            decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        ),
                        //--------------stream--------------//

                        //---------------semester------------//
                        FadeAnimation(0.5, Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey),
                            keyboardType:TextInputType.numberWithOptions(decimal: true) ,
                           // initialValue:userData.name,
                            onChanged: (val){
                              setState(() {
                                phone=val;
                              });
                            },
                            validator: (val)=>val.length!=10?"phone number not Valid": null,
                            decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.grey),
                                labelText: "Phone No.",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        ),
                        FadeAnimation(0.5, Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]))
                          ),
                          child: TextFormField(
                            style: TextStyle(color: Colors.grey),
                            onChanged: (val){
                              setState(() {
                                feedback=val;
                              });
                            },
                            validator: (val)=>val.length<6?"Feedback Must Not Be Empty": null,
                            decoration: InputDecoration(
                                labelText: "FeedBack",
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        ),
                        //----------------semester-----------//
                        SizedBox(height: 40,),
                        FadeAnimation(0.5, InkWell(
                          onTap: ()async{
                            if(_formkey.currentState.validate()){
                              await DatabaseServices().feedback(name??userData.name, email??user.email, phone, feedback);
                              Fluttertoast.showToast(
                                msg: 'Data Updated',
                                toastLength: Toast.LENGTH_SHORT,);
                            }


                            //Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=> Home()));

                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    colors: [Color(0xffD76EF5), Color(0xff8F7AFE)]
                                )
                            ),
                            child: Center(
                              child: Text("Send FeedBack/Suggestion", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }else{
          return Container(
            child: Center(
              child: Text("please wait..."),
            ),
          );
        }
      },
    );
  }
}
