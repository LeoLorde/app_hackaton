import 'package:flutter/material.dart';
import 'app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // If you need async initialization later (e.g., Firebase, shared prefs), 
  // make main() async and await before runApp()

  runApp(const MyApp());
}