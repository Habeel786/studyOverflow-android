import 'dart:ui';
import 'package:flutter/material.dart';


class DrawerScreen extends StatefulWidget {
  final String profilePic;

  DrawerScreen({this.profilePic});

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  String currentOpr;
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffD76EF5), Color(0xff8F7AFE)]
          )
      ),
      padding: EdgeInsets.only(top:50,bottom: 70,left: 10,right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    //backgroundImage: image!=null?MemoryImage(image):AssetImage('assets/images/misc/user.png'),
                    radius: 32.0,
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: 20.0,),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Text(
                    'Habeel Hashmi',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              Text(
                'Computer Engineering Sem-6',
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70
                ),
              ),
              SizedBox(height: 20.0,),
            ],
          ),

          Column(
              children:[
                drawerTile((){}, Icons.calendar_today_outlined, 'Screen 1'),
                drawerTile((){}, Icons.person_search_outlined, 'Screen 2'),
                drawerTile((){}, Icons.person_add_alt_1_outlined, 'Screen 3'),
                drawerTile((){}, Icons.assignment_outlined,'Screen 4'),
                drawerTile((){}, Icons.notifications_none_outlined,'Screen 5'),
                drawerTile((){}, Icons.payments_outlined,'Screen 6'),
                drawerTile((){}, Icons.feedback_outlined,'Screen 7'),
                drawerTile((){}, Icons.info_outline,'Screen 8'),
              ]
          ),

          Row(
            children: [
              Icon(Icons.translate,color: Colors.white,),
              SizedBox(width: 10,),
              Container(width: 2,height: 20,color: Colors.white,),
              SizedBox(width: 10,),
              InkWell(
                  onTap: ()async{

                  },
                  child: Text('Logout',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
              SizedBox(width: 30,),
            ],

          )


        ],
      ),

    );
  }


  Widget drawerTile(Function function, IconData icon , String text){
    return InkWell(
      onTap: function,
      child: Column(
        children: [
          Row(
              children: <Widget>[
                Icon(icon,color: Colors.white,size: 25,),
                SizedBox(width: 20.0,),
                Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17)),
              ]
          ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
