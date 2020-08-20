import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'BaseModel.dart';
import 'Utils.dart' as utils;
import 'Calendar/Calendar.dart' show CalendarView;
import 'Test/Test.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  //Get path for Documents folder
  StartMeUp() async{
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(MainApp());
  }

  StartMeUp();
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext inContext) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BaseApp(),
    );
  }
}

class BaseApp extends StatelessWidget{
  @override
  Widget build(BuildContext inContext){
    return ScopedModel<BaseModel>(
      model: baseModel,
      child: ScopedModelDescendant<BaseModel>(
        builder: (BuildContext inContext, Widget inChild, BaseModel inModel){
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffff2400),
              title: Text(baseModel.title),
            ),
            body: Center(child: IndexedStack(
                index: inModel.stackIndex,
                children: [
                  CalendarView(),
                  defaultApp()
                ]
            ),
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  DrawerHeader(child: Container(child:Image.asset("assets/images/face.jfif"), color: Colors.black,)),
                  ListTile(
                      title: Text('Calendário'),
                      onTap: () {
                        inModel.setStackIndex(0);
                        inModel.setTitle("Calendário");
                        Navigator.pop(inContext);
                      }
                  ),
                  ListTile(
                      title: Text("Second"),
                      onTap: () {
                        inModel.setStackIndex(1);
                        inModel.setTitle("Second");
                        Navigator.pop(inContext);
                      }
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}