import 'package:scoped_model/scoped_model.dart';
import '../BaseModel.dart';

class CalendarEvent{
  int id;
  String title;
  String def;
  String apptDate;
  String apptTime;

  String toString(){
    return "{id=$id, title=$title, def=$def, apptDate=$apptDate, apptDate=$apptTime}";
  }

}

class CalendarModel extends BaseModel{
  String appTime;

  void setAppTime(String inAppTime){
    appTime = inAppTime;
    notifyListeners();
  }
}
CalendarModel calendarModel = CalendarModel();