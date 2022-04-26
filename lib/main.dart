import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graph_package/graph_package.dart';

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
          // ignore: sized_box_for_whitespace
          child: Container(width: scrsize.width,height: scrsize.height),
        ),
      );
    }
    return const Scaffold(body: Center(child: SizedBox(height: 50, width: 50,child: CircularProgressIndicator(),),),);
  }
}

