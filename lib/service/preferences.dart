import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static final PreferenceManager  _instance = PreferenceManager._internal();
  factory PreferenceManager(){
    return _instance;
  }
  late final SharedPreferences _preferences;
  init() async{
    _preferences = await SharedPreferences.getInstance();

  }

  PreferenceManager._internal();




  String? getString(String key){
    return _preferences.getString(key);
  }
  setString(String key , String value) async{
   await _preferences.setString(key, value);
  }
   remove(String key){
    _preferences.remove(key);
  }
  setBool(String key , bool seleted){
    _preferences.setBool(key, seleted);
  }
  bool? getBool(String key){
    return _preferences.getBool(key);

  }
  clear(){
    _preferences.clear();
  }

}