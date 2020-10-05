import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_multi_chip_select/flutter_multi_chip_select.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studyoverflow/models/descmodel.dart';
import 'package:studyoverflow/models/user.dart';
import 'package:studyoverflow/services/database.dart';
import 'package:studyoverflow/services/imageuploadservice.dart';
import 'package:studyoverflow/shared/constants.dart';
import 'package:studyoverflow/shared/loading.dart';
import 'package:studyoverflow/shared/nodatascreen.dart';
import 'package:uuid/uuid.dart';
class AddQuestion extends StatefulWidget {
  String ukey;
  String uyearOfrepeat;
  String uquestion;
  String uanswer;
  String usubject;
  String umarks;
  String uchapter;
  String udiagram;
  String udiagramId;
  int ulike;
  int udisLike;
    AddQuestion({this.uyearOfrepeat, this.uquestion, this.uanswer, this.usubject,
      this.umarks, this.uchapter, this.udiagram, this.udisLike, this.ulike, this.ukey, this.udiagramId});

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final multiSelectKey = GlobalKey<MultiSelectDropdownState>();
  List empty=[''];
  var results;
  final _formkey = GlobalKey<FormState>();
  var menuItems = [2014, 2015, 2016, 2017, 2018, 2019,2020,2021];
  String _yearOfRepeat;
  final List<String> semesters = ['1','2','3','4','5','6','7','8'];
  final List<String> marks = ['1','2','3','4','5','6','7','8'];
  final List<String> courses = ['computer engineering','BSC','commerce','electronics engineering','civil engineering','electrical engineering'];
  bool loading= false;
  bool removeDiagram = false;
  String isSuccessfull="";
  String _currentsubject;
  String _currentMarks;
  String _currentchapter;
  String question;
  String answer;
  String diagramlink;
  String currentImageURL;
  File diagram;
  bool toggleImageText=true;
  String imageName;
  String diagramID;
  Future getDiagramImage()async{
    var diagramImage=await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    setState(() {
      widget.udiagram=null;
      diagram=diagramImage;
    });
  }

  setDiagramID() {
    diagramID = Uuid().v4();
  }
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return loading?Loading():Scaffold(
      backgroundColor: Colors.grey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF2d3447),
        title: Text("AddQuestion"),
        centerTitle: true,

      ),
      body: StreamBuilder(
          stream:DatabaseServices(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            return userData.semester==null||userData.stream==null?
            nothingToShow('''Please select semester and stream from 
                            profile tab''','assets/notfound.png'):
            GestureDetector(
              onTap: (){
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  child: Form(
                      key: _formkey,
                      child:Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          FlutterMultiChipSelect(
                            key: multiSelectKey,
                            elements: List.generate(
                              menuItems.length,
                                  (index) => MultiSelectItem<String>.simple(
                                  actions: [
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          menuItems.remove(menuItems[index]);
                                        });
                                        print("Delete Call at: " + menuItems[index].toString());
                                      },
                                    )
                                  ],
                                  title:menuItems[index].toString(),
                                  value: menuItems[index].toString()),
                            ),
                            label: "Select year(s) where ques. was appeared",
                            values: [
                              //widget.uyearOfrepeat!=null?widget.uyearOfrepeat.substring(1,widget.uyearOfrepeat.length-1):null
                              // Pass Initial value array or leave empty array.
                            ],
                          ),
                          SizedBox(height: 20,),
                          //question
                          TextFormField(
                            initialValue: question??widget.uquestion,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,//Normal textInputField will be displayed
                            maxLines: 5,

                            decoration: textInputDecoration.copyWith(hintText: "Enter Question"),
                            validator: (val)=>val.isEmpty?"Text Field Empty": null,
                            onChanged: (val){
                              setState(() {
                                question=val;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                          //answer
                          TextFormField(
                            initialValue: answer??widget.uanswer,
                            keyboardType: TextInputType.multiline,
                            minLines: 5,//Normal textInputField will be displayed
                            maxLines: 15,
                            decoration: textInputDecoration.copyWith(hintText: "Enter answer"),
                            validator: (val)=>val.isEmpty?"Text Field Empty": null,
                            onChanged: (val){
                              setState(() {
                                answer=val;

                              });
                            },
                          ),
                          SizedBox(height: 20,),
                           StreamBuilder(
                              stream: DatabaseServices().getThumbnail(userData.stream,userData.semester),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  SubjectThumbnail subjectThumbnail = snapshot.data;
                                  List<dynamic> names=subjectThumbnail.thumbnail.keys.toList();
                                  return DropdownButtonFormField(
                                    validator: (val)=>val.isEmpty?"Subject Empty": null,
                                    isExpanded: true,
                                    hint: Text("Select Subject"),
                                    decoration: textInputDecoration,
                                    value: _currentsubject??widget.usubject,
                                    items: names.map((subject){
                                      return DropdownMenuItem(
                                        value: subject,
                                        child: Text("$subject"),
                                      );
                                    }).toList(),
                                    onChanged: (val)=> setState(()=>_currentsubject=val),
                                  );
                                }else{
                                  return Text('Please wait');
                                }
                              }
                          ),
                          SizedBox(height: 20,),
                          //chapter
                          StreamBuilder(
                              stream: DatabaseServices().getChapterNames(_currentsubject??widget.usubject),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  ChapterNames chapterNames = snapshot.data;
                                  List names=chapterNames.chapternames;
                                  return DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text("Select Chapter"),
                                    validator: (val)=>val.isEmpty?"Chapter Empty": null,
                                    decoration: textInputDecoration,
                                    value: _currentchapter??widget.uchapter,
                                    items: names.map((chapter){
                                      return DropdownMenuItem(
                                        value: chapter,
                                        child: Text("$chapter"),
                                      );
                                    }).toList(),
                                    onChanged: (val)=> setState(()=>_currentchapter=val),
                                  );
                                }else{
                                  return DropdownButtonFormField(
                                    isExpanded: true,
                                    hint: Text("Select Chapter"),
                                    validator: (val)=>val.isEmpty?"Chapter Empty": null,
                                    decoration: textInputDecoration,
                                    value: _currentchapter??widget.uchapter,
                                    onChanged: (val)=> setState(()=>_currentchapter=val),
                                  );
                                }

                              }
                          ),
                          SizedBox(height: 20,),
                          //course
                          DropdownButtonFormField(
                            autofocus: true,
                            hint: Text("Select marks"),
                            decoration: textInputDecoration,
                            validator: (val)=>val.isEmpty?"Marks Empty": null,
                            value: _currentMarks??widget.umarks,
                            items: marks.map((mark){
                              return DropdownMenuItem(
                                value: mark,
                                child: Text("$mark"),
                              );
                            }).toList(),
                            onChanged: (val)=> setState(()=>_currentMarks=val),
                          ),
                          SizedBox(height: 20,),
                          //chapter
                          Center(
                            child: diagram == null &&
                                (widget.udiagram == null ||
                                    widget.udiagram == '') ? Text(
                                'Diagram empty') :
                            Stack(
                              children: [
                                Visibility(
                                  visible: widget.udiagram == null ? diagram !=
                                      null : widget.udiagram != '',
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                        icon: Icon(Icons.clear),
                                        onPressed: () async {
                                          setState(() {
                                            removeDiagram = true;
                                            diagram = null;
                                            diagramlink = null;
                                            diagramID = null;
                                            widget.udiagram = null;
                                          });
                                        }),
                                  ),
                                ),
                                ShowImage()
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          InkWell(
                            onTap: () {
                              getDiagramImage();
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFF2d3447)
                              ),
                              child: Center(
                                child: Text("Select a diagram if required",
                                  style: TextStyle(color: Colors.white,
                                      fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          InkWell(
                            onTap: () async {
                              if (_formkey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                _yearOfRepeat =
                                    this.multiSelectKey.currentState.result
                                        .toString();
                                if (diagram != null) {
                                  setDiagramID();
                                  diagramlink = await UploadImage().uploadImage(
                                      widget.udiagramId ?? diagramID, diagram,
                                      'diagrams/');
                                }
                                if (removeDiagram) {
                                  await DatabaseServices().deleteImage(
                                      'diagrams/', widget.udiagramId);
                                  widget.udiagramId = null;
                                }
                                dynamic result = await DatabaseServices(
                                    uid: user.uid).setUserQuestion(
                                    question ?? widget.uquestion,
                                    answer ?? widget.uanswer,
                                    _currentsubject ?? widget.usubject,
                                    userData.stream,
                                    userData.semester,
                                    _currentchapter ?? widget.uchapter,
                                    currentImageURL ?? diagramlink ??
                                        widget.udiagram,
                                    _yearOfRepeat == "[]"
                                        ? widget.uyearOfrepeat
                                        : _yearOfRepeat,
                                    _currentMarks ?? widget.umarks,
                                    widget.ulike ?? 0,
                                    widget.udisLike ?? 0,
                                    widget.ukey,
                                    widget.udiagramId ?? diagramID
                                );
                                print('result:${result}');
                                print("Data entered successfully");
                                if (result != null) {
                                  setState(() {
                                    loading = false;
                                    Fluttertoast.showToast(
                                      msg: 'Error Occured',
                                      toastLength: Toast.LENGTH_SHORT,);
                                  });
                                } else {
                                  setState(() {
                                    loading = false;
                                    Fluttertoast.showToast(
                                      msg: 'Data Updated!',
                                      toastLength: Toast.LENGTH_SHORT,);
                                  });
                                }
                              }
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFF2d3447)
                              ),
                              child: Center(
                                child: Text("Submit", style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            );
          }else{
            return Loading();
          }
        }
      ),
    );
  }

  Widget ShowImage(){
    return Center(
      child: diagram == null && widget.udiagram == null
          ? Text('Diagram empty')
          : UploadImage().displayDiagram(diagram, widget.udiagram),
    );
  }
  Widget ShowTextField(){
    return TextFormField(
      decoration: textInputDecoration.copyWith(hintText: "Enter Image Url"),
      onChanged: (val){
        setState(() {
          currentImageURL=val;
        });
      },
    );
  }
}
