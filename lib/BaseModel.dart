import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model{
  int stackIndex = 0;
  var currentEditing;
  List entityList;
  String chosenDate;
  String title = "Bem Vindo";

  void setTitle(String inTitle){
    title = inTitle;
    notifyListeners();
  }

  void setStackIndex(int index){
    stackIndex = index;
    notifyListeners();
  }

  void setChosenDate(String inDate){
    chosenDate = inDate;
    notifyListeners();
  }

  void loadData(dynamic inDatabase){
    entityList = inDatabase.getAll();
    notifyListeners();
  }
}

BaseModel baseModel = BaseModel();