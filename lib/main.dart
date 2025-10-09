import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app/app.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (kIsWeb) {
    // ✅ For Web
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // ✅ For Desktop & Mobile
    sqfliteFfiInit(); // optional but safe for desktop
    databaseFactory = databaseFactoryFfi;
  }

  await Hive.initFlutter();
  await Hive.openBox('issues');

  runApp(const MyApp());
}