import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    if(myData != null){
      return Scaffold(
        body: Column(
          children: [
            a==false?
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(onPressed:(){
                setState(() {
                  a=!a;
                  fn.requestFocus();
                });
              } ,  child: const Icon(Icons.play_arrow),style:
              ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.green),),),
            ):
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed:(){
                  setState(() {
                    a=!a;
                    fn.unfocus();
                  });
                } , child: const Icon(Icons.stop),style:
              ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(Colors.green)),),
            ),
            CustomPaint(
              painter: Graphcls(myData!,initx),
              child: Container(color:Colors.black12,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height-80,),
            ),

            Slider(
              focusNode: fn,
              thumbColor: Colors.black,
              activeColor: Colors.black54,
              inactiveColor: Colors.black12,
              value: initx as double,
              min: 0,
              max: myData!['x'].length/1.2280701754385965,
              onChanged: (value) {
                setState(() {
                  initx = value.toInt();
                });
              },
            ),
          ],
        ),
      );
    }
    return const Scaffold(body: Center(child: SizedBox(height: 50, width: 50,child: CircularProgressIndicator(),),),);
  }
}

class Graphcls extends CustomPainter{
  Map<String, dynamic> myData;
  int initx;
  Graphcls(this.myData,this.initx);
  @override
  void paint(Canvas canvas, Size size)
  {
    var x=[];
    var points=[];
    for(int i=0;i<myData['x'].length;i++)
    {
      x.add(((double.parse(myData['x'][i].substring(11,13)))*3600 +(double.parse(myData['x'][i].substring(14,16)))*60+(double.parse(myData['x'][i].substring(17,19))))/40);
    }
    for(int i=initx;i<x.length;i++)
    {
        points.add(Offset((x[i]-x[0]-(initx)/10+50)+(i-initx)*0.866,size.height-50-myData['y'][i]*size.height/240));
    }
    var l1=[0,97,116,135,154,174,193],r1=[0,50,60,70,80,90,100];
    var paint=Paint()..color=Colors.black..strokeWidth=3.0..strokeCap=StrokeCap.round;

    var l=[],r=[];
    // debugPrint(size.width.toString());
    for(int i=0;i<l1.length;i++)
    {
      l.add(l1[i]*size.height/240);
      r.add(r1[i]*size.height/240);
    }
    Offset p1=Offset(50,size.height-80-(l[l.length-1]));
    Offset p3=Offset(3*size.width/2-(x[x.length-1]-x[0]+70),size.height-50);
    Offset p2=Offset(50, size.height- 50);
    Offset p4=Offset(3*size.width/2-(x[x.length-1]-x[0]+70),size.height-50);
    Offset p5=Offset(3*size.width/2-(x[x.length-1]-x[0]+70),size.height-80-(l[l.length-1]));
    canvas.drawLine(p4, p5, paint);
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p3, p2, paint);
    var color=[Colors.lightGreen,Colors.orange,Colors.grey,Colors.blueGrey,Colors.blue,Colors.orangeAccent];
    for(int i=0;i<l.length-1;i++)
    {
      Offset point1=Offset(50+1.5,size.height-50-(l[i]+l[i+1])/2);
      Offset point2=Offset(3*size.width/2-(x[x.length-1]-x[0]+70+1.5),size.height-50-(l[i]+l[i+1])/2);
      canvas.drawLine(point1, point2, Paint()
        ..color = color[i]
        ..strokeWidth = (l[i+1]-l[i])*(size.height+1)/size.height
        ..style = PaintingStyle.stroke);
    }//colors

    for(int i=0;i<l.length;i++)
    {
      Offset point1=Offset(50-25,size.height-50-l[i]);
      Offset point2=Offset(3*size.width/2-(x[x.length-1]-x[0])-25,size.height-50-l[i]);
      canvas.drawLine(point1, point2, paint);
    }//region lines
    for(int i=0;i<l.length-1;i++)
    {
      TextSpan span1 = TextSpan(style: const TextStyle(color: Colors.black), text:(l1[i+1]).toString());
      TextPainter tp = TextPainter(text: span1, textDirection: TextDirection.ltr);
      tp.layout();
      Offset point3=Offset(50/2-5,size.height-50-(l[i+1]));
      tp.paint(canvas,point3);
      //left points
      TextSpan span2 = TextSpan(style: const TextStyle(color: Colors.black), text:(r1[i+1]).toString());
      TextPainter tp2 = TextPainter(text: span2, textDirection: TextDirection.ltr);
      tp2.layout();
      Offset point4=Offset(3*size.width/2-(x[x.length-1]-x[0]+50),size.height-50-(l[i+1]));
      tp2.paint(canvas,point4);
      //right points
    }
    for(int i=0;i<points.length-1;i++)
    {
      if(points[i].dx<=3*size.width/2-(x[x.length-1]-x[0]+70))
      {
        canvas.drawLine(points[i], points[i+1], Paint()..color=Colors.red..strokeWidth=3.0..strokeCap=StrokeCap.round);
      }
    }//graph
     var pl=[],b=[],a=[],x1=[];
    var n=(3*size.width/2-(x[x.length-1]-x[0]+70)).round();
    for(var i=25;i<n;i+=90)
      {
         x1.add(i);
         a.add(i+initx);
      }//x-points
    for(int i=0;i<a.length;i++)
    {
      i==0?pl.insert(i,Offset(25,size.height-50)):pl.insert(i,Offset(x1[i],size.height-50));
      b.add(myData['x'][a[i]].substring(11,19));
    }

    var text1=['bpm','%'];
    var text=List.from(text1)..addAll(b);
    var plots1=[ Offset(50/2-5,size.height-80-(l[l.length-1])), Offset(3*size.width/2-(x[x.length-1]-x[0]+50),size.height-80-(l[l.length-1]))];
    var plots=[...plots1,...pl];
    for(int i=0;i<text.length;i++)
    {
      TextSpan span = TextSpan(style:const TextStyle(color: Colors.black), text:text[i]);
      TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      Offset point=plots[i];
      tp.paint(canvas,point);
    }
  }

  @override
  bool shouldRepaint(covariant oldDelegate) {
    return false;
  }
}