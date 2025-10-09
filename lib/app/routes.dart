import 'package:flutter/material.dart';

import 'package:app_hackaton/presentation/pages/home_page.dart';
import 'package:app_hackaton/presentation/pages/relatarProblema_page.dart';
import 'package:app_hackaton/presentation/pages/relatoAnonimo.dart';
import 'package:app_hackaton/presentation/pages/status.dart';
import 'package:app_hackaton/presentation/pages/map_page.dart';
import 'package:app_hackaton/presentation/pages/profile_page.dart';
import 'package:app_hackaton/presentation/pages/account_register.dart';
import 'package:app_hackaton/presentation/pages/login_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String reportIssue = '/report-issue';
  static const String anonymousReport = '/anonymous-report';
  static const String issueStatus = '/issue-status';
  static const String map = '/map';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String login = '/login';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),
    reportIssue: (context) => RelatarproblemaPage(),
    anonymousReport: (context) => RelatoAnonimo(),
    map: (context) => MapPage(),
    issueStatus: (context) => StatusPage(),
    profile: (context) => EditProfile(),
    register: (context) => AccountRegister(),
    login: (context) => LoginPage(),
  };
}
