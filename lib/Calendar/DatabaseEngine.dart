import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'CalendarModel.dart';
import "../Utils.dart" as utils;

class DatabaseEngine{
  DatabaseEngine._();
  static final DatabaseEngine db = DatabaseEngine._();

  Database _db;
//get database
  Future get database async{
    if (_db = null){
     _db = await init();
    }
    return _db;
  }
  //find | create a database
  Future<Database> init() async{
    String path = join(utils.docsDir.path, "kyokushinCalendar.db");
    Database db = await openDatabase(path, version: 1,
        onConfigure: (Database inDb) async{
          await inDb.execute(
            "CREATE TABLE IF NOT EXISTS ("
                "id INTEGER PRIMARY KEY,"
                "title TEXT,"
                "def TEXT,"
                "apptDate,"
                "apptTime,"
                ")"
          );
        }
    );
  return db;
  }

  CalendarEvent  eventFromMap(Map inMap){
    CalendarEvent calendarEvent = CalendarEvent();
    calendarEvent.id = inMap["id"];
    calendarEvent.title = inMap["title"];
    calendarEvent.def = inMap["def"];
    calendarEvent.apptDate = inMap["apptDate"];
    calendarEvent.apptTime = inMap["apptTime"];
    return calendarEvent;
  }

  Map<String, dynamic> mapFormEvent(CalendarEvent inEvent){
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inEvent.id;
    map["title"] = inEvent.title;
    map["def"] = inEvent.def;
    map["apptDate"] = inEvent.apptDate;
    map["apptTime"] = inEvent.apptTime;
    return map;
  }

  Future create(inEvent) async{
    Database db = await database;
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM kyokushinCalendar");
    int id = val.first["id"];
    if (id==null){id = 1;}
    return db.rawInsert(
        "INSERT INTO kyokushinCalendar (id, title, def, apptDate, apptTime) VALUES (?,?,?,?,?)",
    [
      id,
      inEvent.title,
      inEvent.def,
      inEvent.apptDate,
      inEvent.aptTime
    ]);
  }

  Future<CalendarEvent> get(int inID) async{
    Database db = await database;
    var rec = await db.query("kyokushinCalendar", where : "id = ?", whereArgs : [ inID ]);
    return eventFromMap(rec.first);
  }

  Future update(CalendarEvent inEvent) async{
    Database db = await database;
    return await db.update("kyokushinCalendar", mapFormEvent(inEvent), where: "id = ?", whereArgs: [inEvent.id]);
  }

  Future delete(int inID) async{
    Database  db = await database;
    return db.delete("kyokushinCalendar", where: "id = ?", whereArgs: [inID]);
  }
}