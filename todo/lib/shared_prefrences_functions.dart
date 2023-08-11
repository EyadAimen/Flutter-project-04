import 'package:shared_preferences/shared_preferences.dart';
class TodoListSharedPrefs{

  static  setTodoWidget(String key,List<String> list) async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setStringList(key, list); 
  }
  

  static Future getTodoWidget(String key) async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList(key);
  }
  static setPath(bool ispath) async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool("path", ispath);
  }
  
  static Future getPath() async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool("path");
  }
  static Future setImage(String imagePath) async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString("profileImage", imagePath);
  }
  static Future getImage() async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString("profileImage");
  }

  static Future deleteImage() async{
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    sharedPref.remove("profileImage");
  }
}