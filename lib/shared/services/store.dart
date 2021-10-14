import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Store {
  read(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      String? res = prefs.getString(key);
      var decoded = jsonDecode(res!);
      return decoded;
    }
    return null;
  }

  save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('from');
    prefs.remove('to');
    prefs.remove('type');
    prefs.remove('moving-size');
    prefs.remove('office-size');
    prefs.remove('mover-number');
    prefs.remove('supplies');
    prefs.remove('vehicle');
    prefs.remove('phone');
    prefs.remove('me');
    prefs.remove('floors');
    prefs.remove('items');
    prefs.remove('instructions');
    prefs.remove('mover');
    prefs.remove('moving-date');
    prefs.remove('moving-time');
    prefs.remove('contacts');
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  check(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key) ? true : false;
  }
}
