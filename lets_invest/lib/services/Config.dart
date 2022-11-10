import 'dart:convert';

import 'package:flutter/services.dart';

class Config {
  static Future<String> getValue(String key) async {
    final String configJson = await rootBundle.loadString('assets/config/config.json');
    final config = await json.decode(configJson);
    return config[key];
  }  
}