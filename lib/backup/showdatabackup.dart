//import 'package:admob_flutter/admob_flutter.dart';
//import 'package:draggable_scrollbar/draggable_scrollbar.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:studyoverflow/services/admob_service.dart';
//import 'package:studyoverflow/services/database.dart';
//import 'package:studyoverflow/models/descmodel.dart';
//import 'package:studyoverflow/shared/loading.dart';
//import 'package:studyoverflow/shared/nodatascreen.dart';
//
//
//class Demo extends StatefulWidget {
//  final String subject;
//  final String semester;
//  final String stream;
//  final String chapter;
//
//  Demo({this.subject,this.semester,this.stream,this.chapter});
//
//  @override
//  _DemoState createState() => _DemoState();
//}
//
//class _DemoState extends State<Demo> {
//  ScrollController _arrowsController = ScrollController();
//  List<Data> mydata=List();
//  List<Data> filteredMydata=[];
//  List<Data> tempdata=[];
//
//  bool isSearching=false;
//  bool notFound=false;
//  var _data;
//  bool adFlag=false;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    Admob.initialize('ca-app-pub-9118153038397153~5910414684');
//    _data= DatabaseServices().dataAboutQues(widget.stream,widget.semester,widget.chapter,widget.subject);
//  }
//  @override
//  Widget build(BuildContext context) {
//    return StreamBuilder(
//      stream:_data,
//      builder: (_ , snapshot){
//        if(snapshot.connectionState==ConnectionState.waiting){
//          return Loading();
//        }else{
//          mydata= snapshot.data;
//          filterthedata(String value){
//            setState(() {
//              tempdata=mydata.where((u) =>
//              (u.question.toLowerCase().contains(value.toLowerCase()))).toList();
//            }
//            );
//            tempdata.isEmpty?notFound=true:notFound=false;
//            print(tempdata);
//          }
//          if(tempdata.isEmpty){
//            filteredMydata=mydata;
//          }else{
//            filteredMydata=tempdata;
//          }
//          return mydata.isEmpty?nothingToShow("Data is to be added",'assets/notfound.png'):Scaffold(
//            appBar: AppBar(
//              elevation: 0,
//              title: !isSearching?Text('Questions'):
//              AnimatedContainer(
//                duration: Duration(milliseconds: 500),
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(30),
//                    color: Colors.white
//                ),
//                child: Padding(
//                  padding: const EdgeInsets.only(left: 20,right: 20),
//                  child: TextField(
//                    onChanged: (string){
//                      filterthedata(string);
//                    },
//                    style: TextStyle(
//                        color: Colors.black
//                    ),
//                    decoration: InputDecoration(
//                        border: InputBorder.none,
//                        icon: Icon(Icons.search),
//                        hintText: "Search Question Here",
//                        hintStyle: TextStyle(
//                            color: Colors.grey[600]
//                        )
//                    ),
//                  ),
//                ),
//              ),
//              actions: [
//                isSearching?IconButton(
//                    icon: Icon(Icons.clear,color: Colors.white,),
//                    onPressed: (){
//                      setState(() {
//                        isSearching=false;
//                      });
//                    }): IconButton(
//                    icon: Icon(Icons.search,color: Colors.white,),
//                    onPressed: (){
//                      setState(() {
//                        isSearching=true;
//                      });
//                    })
//              ],
//              centerTitle: true,
//              backgroundColor: Color(0xffD76EF5),
//            ),
//            body: notFound?nothingToShow('', 'assets/searchnotfound.png'):DraggableScrollbar.arrows(
//              controller: _arrowsController,
//              child: ListView.builder(
//                  controller: _arrowsController,
//                  itemCount: tempdata.isEmpty?mydata.length:filteredMydata.length,
//                  itemBuilder: (_, index){
//                    if((index+1)%11==0){
//                      adFlag=true;
//                    }else{
//                      adFlag=false;
//                    }
//                    return adFlag?AdmobService().listtileWithAd(index,context,filteredMydata[index].answer,
//                        filteredMydata[index].question,filteredMydata[index].chapter,filteredMydata[index].diagram,
//                        filteredMydata[index].yearofrepeat,filteredMydata[index].marks,filteredMydata[index].postedBy,
//                        filteredMydata[index].postedOn, filteredMydata[index].like,filteredMydata[index].dislike,
//                        filteredMydata[index].semester
//                    ):AdmobService().listtileWithoutAd(index,context,filteredMydata[index].answer,
//                        filteredMydata[index].question,filteredMydata[index].chapter,filteredMydata[index].diagram,
//                        filteredMydata[index].yearofrepeat,filteredMydata[index].marks,filteredMydata[index].postedBy,
//                        filteredMydata[index].postedOn,filteredMydata[index].like,filteredMydata[index].dislike,
//                        filteredMydata[index].semester
//                    );
//                  }
//              ),
//            ),
//          );
//        }
//      },
//    );
//  }
//}
