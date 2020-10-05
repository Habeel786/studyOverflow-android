import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/services/Animation/FadeAnimation.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/services/imageuploadservice.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/dialogs.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/widgets/gradientbutton.dart';
class SetStream extends StatefulWidget {
  @override
  _SetStreamState createState() => _SetStreamState();
}
class _SetStreamState extends State<SetStream> {

  final _formkey = GlobalKey<FormState>();
  List semesters=['1','2','3','4','5','6'];
  List streams=['computer engineering','civil engineering','mechanical engineering','electronics','electrical engineering'];
  String _currentStream;
  String _currentSemester;
  String name;
  String imageText;
  File profilepic;
  String userProfilePic;
  bool isSuccessful;

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: DatabaseServices(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              return SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: SingleChildScrollView(
                    child: FadeAnimation(0.5,
                      Column(
                        children: [
                          SizedBox(height: 20,),
                          Center(
                            child: Column(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Color(0xffD76EF5),
                                    radius: 50,
                                    child: (userData.profilepic == null ||
                                        userData.profilepic == '') &&
                                        profilepic == null ?
                                    Text(
                                      getInitials(userData.name.trimLeft()),
                                      style: TextStyle(
                                          fontSize: 50, color: Colors.white),
                                    ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: profilepic != null ? Image.file(
                                          profilepic) :
                                      CachedNetworkImage(
                                        imageUrl: userData.profilepic,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                            CircularProgressIndicator(
                                                value: downloadProgress
                                                    .progress),
                                      ),

                                    )
                                ),
                                SizedBox(height: 20,),
                                GestureDetector(
                                  onTap: () async {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2d3447),
                                              borderRadius: new BorderRadius
                                                  .only(
                                                topLeft: const Radius.circular(
                                                    25.0),
                                                topRight: const Radius.circular(
                                                    25.0),
                                              ),
                                            ),
                                            height: 190,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20, horizontal: 20),
                                            child: Column(
                                                children: [
                                                  Align(
                                                    child: Text('Profile Photo',
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                          color: Colors.white
                                                      ),),
                                                    alignment: Alignment
                                                        .topLeft,
                                                  ),
                                                  SizedBox(height: 30,),
                                                  Row(
                                                    children: [
                                                      Column(
                                                          children: [
                                                            FloatingActionButton(
                                                                child: Icon(
                                                                    Icons
                                                                        .delete),
                                                                backgroundColor: Colors
                                                                    .red,
                                                                onPressed: () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  try {
                                                                    bool delete = await DialogBox(
                                                                        context,
                                                                        'Delete',
                                                                        'Delete Profile Picture?');
                                                                    print(
                                                                        "delete =$delete");
                                                                    setState(() {
                                                                      profilepic =
                                                                      null;
                                                                    });
                                                                    if (delete) {
                                                                      userProfilePic =
                                                                      '';
                                                                      await DatabaseServices()
                                                                          .deleteImage(
                                                                          'profilePic/',
                                                                          user
                                                                              .uid);
                                                                      isSuccessful =
                                                                      await DatabaseServices(
                                                                          uid: user
                                                                              .uid)
                                                                          .updateProfilePic(
                                                                          userProfilePic);
                                                                      if (isSuccessful) {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg: 'Profile picture removed',
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,);
                                                                      } else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg: 'Error',
                                                                          toastLength: Toast
                                                                              .LENGTH_SHORT,);
                                                                      }
                                                                      Navigator
                                                                          .pop(
                                                                          context);
                                                                    } else {
                                                                      Navigator
                                                                          .pop(
                                                                          context);
                                                                    }
                                                                  } catch (e) {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                      msg: 'Profile picture doesnt exists',
                                                                      toastLength: Toast
                                                                          .LENGTH_SHORT,);
                                                                  }
                                                                }
                                                            ),
                                                            SizedBox(
                                                              height: 5,),
                                                            Text('Remove',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ]
                                                      ),
                                                      SizedBox(width: 30,),
                                                      Column(
                                                          children: [
                                                            FloatingActionButton(
                                                              child: Icon(Icons
                                                                  .photo),
                                                              backgroundColor: Colors
                                                                  .blue,
                                                              onPressed: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                File tempprofilepic = await UploadImage()
                                                                    .getImage(
                                                                    ImageSource
                                                                        .gallery);
                                                                //File tempprofilepic=  await CompressImage.takeCompressedPicture(context);
                                                                File croppedFile = await ImageCropper
                                                                    .cropImage(
                                                                    sourcePath: tempprofilepic
                                                                        .path,
                                                                    aspectRatioPresets: [
                                                                      CropAspectRatioPreset
                                                                          .square,
                                                                    ],
                                                                    androidUiSettings: AndroidUiSettings(
                                                                        toolbarTitle: 'Crop Image',
                                                                        toolbarColor: Color(
                                                                            0xFF2d3447),
                                                                        toolbarWidgetColor: Colors
                                                                            .white,
                                                                        initAspectRatio: CropAspectRatioPreset
                                                                            .original,
                                                                        lockAspectRatio: false),
                                                                    iosUiSettings: IOSUiSettings(
                                                                      minimumAspectRatio: 1.0,
                                                                    )
                                                                );
                                                                setState(() {
                                                                  profilepic =
                                                                      croppedFile;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 5,),
                                                            Text('Gallery',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ]
                                                      ),
                                                      SizedBox(width: 30,),
                                                      Column(
                                                          children: [
                                                            FloatingActionButton(
                                                              child: Icon(Icons
                                                                  .camera),
                                                              backgroundColor: Colors
                                                                  .amber,
                                                              onPressed: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                File tempprofilepic = await UploadImage()
                                                                    .getImage(
                                                                    ImageSource
                                                                        .camera);
                                                                File croppedFile = await ImageCropper
                                                                    .cropImage(
                                                                    sourcePath: tempprofilepic
                                                                        .path,
                                                                    aspectRatioPresets: [
                                                                      CropAspectRatioPreset
                                                                          .square,
                                                                    ],
                                                                    androidUiSettings: AndroidUiSettings(
                                                                        toolbarTitle: 'Crop Image',
                                                                        toolbarColor: Color(
                                                                            0xFF2d3447),
                                                                        toolbarWidgetColor: Colors
                                                                            .white,
                                                                        initAspectRatio: CropAspectRatioPreset
                                                                            .original,
                                                                        lockAspectRatio: true),
                                                                    iosUiSettings: IOSUiSettings(
                                                                      minimumAspectRatio: 1.0,
                                                                    )
                                                                );
                                                                setState(() {
                                                                  profilepic =
                                                                      croppedFile;
                                                                });
                                                              },
                                                            ),
                                                            SizedBox(
                                                              height: 5,),
                                                            Text('Camera',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ]
                                                      ),
                                                      SizedBox(width: 30,),

                                                    ],
                                                  ),
                                                ]
                                            ),
                                          );
                                        });
                                  },
                                  child: Text(
                                    'Change Profile Picture',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _formkey,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: <Widget>[
                                  //--------------stream--------------//
                                  Container(
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2d3447),
                                      border: Border.all(
                                          color: Color(0xffD76EF5)
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(
                                                  color: Colors.grey))
                                          ),
                                          child: DropdownButtonFormField(
                                            dropdownColor: Color(0xFF2d3447),
                                            style: TextStyle(
                                                color: Colors.white70),
                                            isExpanded: true,
                                            value: _currentStream ??
                                                userData.stream,
                                            items: streams.map((stream) {
                                              return DropdownMenuItem(
                                                value: stream,
                                                child: Text("$stream"),
                                              );
                                            }).toList(),
                                            onChanged: (val) => setState(() =>
                                            _currentStream = val),
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                labelText: 'Stream',
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                        //--------------stream--------------//

                                        //---------------semester------------//
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(
                                                  color: Colors.grey))
                                          ),
                                          child: DropdownButtonFormField(
                                            style: TextStyle(
                                                color: Colors.white70),
                                            dropdownColor: Color(0xFF2d3447),
                                            value: _currentSemester ??
                                                userData.semester,
                                            items: semesters.map((semester) {
                                              return DropdownMenuItem(
                                                value: semester,
                                                child: Text("$semester"),
                                              );
                                            }).toList(),
                                            onChanged: (val) => setState(() =>
                                            _currentSemester = val),
                                            decoration: InputDecoration(
                                                labelText: 'Semester',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                        //--------------------------semester---------------------------//
                                        //--------------------------name-------------------------------//
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              border: Border(bottom: BorderSide(
                                                  color: Colors.grey))
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(
                                                color: Colors.white70),
                                            initialValue: userData.name,
                                            onChanged: (val) {
                                              setState(() {
                                                name = val.trim();
                                              });
                                            },
                                            validator: (val) =>
                                            val.length < 6
                                                ? "There must be 6 characters minimum"
                                                : null,
                                            decoration: InputDecoration(
                                                labelText: 'Name',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5,
                                              right: 10,
                                              left: 10,
                                              bottom: 20),
                                          child: Text(
                                            'This name will be displayed along your contribution.make sure to choose appropriate one',
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  //----------------Name-----------//
                                  SizedBox(height: 40,),
                                  GradientButton(
                                    colors: [
                                      Color(0xffD76EF5),
                                      Color(0xff8F7AFE)
                                    ],
                                    text: 'Update',
                                    onTap: () async {
                                      if (profilepic != null) {
                                        //
                                        userProfilePic =
                                        await UploadImage().uploadImage(
                                            user.uid, profilepic,
                                            'profilePic/');
                                        isSuccessful =
                                        await DatabaseServices(uid: user.uid)
                                            .updateProfilePic(userProfilePic);
                                        if (isSuccessful) {
                                          Fluttertoast.showToast(
                                            msg: 'Profile picture updated',
                                            toastLength: Toast.LENGTH_SHORT,);
                                          print(
                                              'sucessfully uploaded profile pic');
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: 'Error!',
                                            toastLength: Toast.LENGTH_SHORT,);
                                          print('unsucessfull');
                                        }
                                        return;
                                      }
                                      if (_formkey.currentState.validate()) {
                                        print(_currentSemester);
                                        print(_currentStream);
                                        await DatabaseServices(uid: user.uid)
                                            .updateUserData(
                                          _currentSemester ?? userData.semester,
                                          name ?? userData.name,
                                          _currentStream ?? userData.stream,
                                          userData.profilepic,
                                        );
                                        Fluttertoast.showToast(
                                          msg: 'Data Updated',
                                          toastLength: Toast.LENGTH_SHORT,);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Loading();
            }
          }
      ),
    );
  }
}
