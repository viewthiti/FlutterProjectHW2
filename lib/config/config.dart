import 'dart:convert';

import 'package:flutter/services.dart';

class Configuration {
  static Future<Map<String, dynamic>> getConfig() {
    //jsonDecode => Convert String to object
    return rootBundle.loadString('assets/config/config.json').then(
          (value) => jsonDecode(value) as Map<String, dynamic>,
        );
  }
}
