import "package:flutter/material.dart";
import "dart:math" as math;
import 'package:flutter_calendar_carousel/classes/event.dart';
import "package:flutter_calendar_carousel/flutter_calendar_carousel.dart" show CalendarCarousel;
import 'package:scoped_model/scoped_model.dart';
import 'CalendarModel.dart';

//builder
class CalendarView extends StatelessWidget{
  @override
  Widget build(BuildContext inContext){
    return ScopedModel<CalendarModel>(
      model: calendarModel,
      child: ScopedModelDescendant(
        builder: (BuildContext inContext, Widget inChild, CalendarModel inModel){
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: (){}
            ),
            body: IndexedStack(
              index: inModel.stackIndex,
              children: <Widget>[Calendar()],
            ),
          );
        },
      ),
    );
  }
}


//Calendar
class Calendar extends StatelessWidget{
  @override
  Widget build(BuildContext inContext){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: CalendarCarousel(
        headerTextStyle: TextStyle(color: Colors.black, fontSize: 25),
        weekendTextStyle: TextStyle(color: Colors.red),
        thisMonthDayBorderColor: Colors.white,
        daysHaveCircularBorder: true,
        customDayBuilder: _customDayBuilder,
        onDayPressed: (DateTime inDateTime, List<Event> inEvents){},
        onDayLongPressed: (DateTime inDateTime){},
      ),
    );
  }
  //SpecialDays
  Widget _customDayBuilder (
      bool isSelectable,
      int index,
      bool isSelectedDay,
      bool isToday,
      bool isPrevMonthDay,
      TextStyle textStyle,
      bool isNextMonthDay,
      bool isThisMonthDay,
      DateTime day,
      ){
    if ((day.weekday == 1 || day.weekday == 3)  && isThisMonthDay){
      return SpinDisk();
    }
  }
}

//The spinDisk

class SpinDisk extends StatefulWidget{
  SpinDisk({Key key}) : super(key: key);
  @override
  _SpinDisk createState() => _SpinDisk();
}

class _SpinDisk extends State<SpinDisk> with TickerProviderStateMixin{
  AnimationController controller;
  dynamic _image = Image.asset("assets/images/face.png");

  @override
  void initState(){
  super.initState();
  controller = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  void move(){
    if (controller.isCompleted) {
      controller.animateBack(0);
      print("back");
    }
    else{
      controller.animateTo(1);
      print("forwards");
    }
  }

  void updateImage(){
    setState((){_image = (controller.value < 0.5) ? Image.asset("assets/images/face.png") : Text("HA");});
  }

  @override
  Widget build(BuildContext inContext){
    controller.addListener(() {
        updateImage();
    });
      return AnimatedBuilder(
        animation: controller,
        child: IconButton(
          icon: _image,
          onPressed: (){setState(() {
            this.move();
          });}
        ),
        builder: (BuildContext inContext, Widget inChild){
          return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(math.pi * controller.value),
            alignment: FractionalOffset.center,
            child: inChild,
          );
        },
      );
  }
}