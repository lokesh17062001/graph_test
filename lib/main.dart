import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph/graph.dart';

void main() => runApp(const MaterialApp(
    home: Mygraph(),
    debugShowCheckedModeBanner: false,
  ));

class Mygraph extends StatefulWidget {
  const Mygraph({Key? key}) : super(key: key);
  @override
  State<Mygraph> createState() => _MygraphState();
}

class _MygraphState extends State<Mygraph> {
  Map<String, dynamic>? myData;
  var zoom=0.1,a=false,initx=0;
  FocusNode fn = FocusNode();

  @override
  void initState() {
    readjs();
    super.initState();
  }
  void readjs() async {
    myData = json.decode(await rootBundle.loadString('chart_data.json'));
  }
  @override
  Widget build(BuildContext context) {
    var scrsize=MediaQuery.of(context).size;
    if(myData != null){
      return Scaffold(
        body: CustomPaint(
          painter:Graphcls(myData!),
          child: Container(color:Colors.black12,width: scrsize.width,height: scrsize.height),
        ),
      );
    }
    return const Scaffold(body: Center(child: SizedBox(height: 50, width: 50,child: CircularProgressIndicator(),),),);
  }
}

