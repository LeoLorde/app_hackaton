import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app/app.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  // Web
  // databaseFactory = databaseFactoryFfiWeb;
  // } else {
  // Desktop e Mobile
  // sqfliteFfiInit();
  databaseFactory = databaseFactory;
  // }

  // await Hive.initFlutter();
  // await Hive.openBox('issues');

  runApp(const MyApp());
}
