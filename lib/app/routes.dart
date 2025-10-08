import 'package:app_hackaton/presentation/pages/relatarProblema_page.dart';
import 'package:app_hackaton/presentation/pages/relatoAnonimo.dart';
import 'package:app_hackaton/presentation/pages/status.dart';
import 'package:flutter/material.dart';

// Import your pages
import '../presentation/pages/home_page.dart';
import 'package:app_hackaton/presentation/pages/map_page.dart';

//import '../presentation/pages/profile/profile_page.dart';
//import '../presentation/pages/report_issue/report_issue_page.dart';
//import '../presentation/pages/anonymous_report/anonymous_report_page.dart';
//import '../presentation/pages/map/map_page.dart';
//import '../presentation/pages/issue_status/issue_status_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String selectCity = '/select-city';
  static const String profile = '/profile';
  static const String reportIssue = '/report-issue';
  static const String anonymousReport = '/anonymous-report';
  static const String map = '/map';
  static const String issueStatus = '/issue-status';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),

    //profile: (context) => const ProfilePage(),
    reportIssue: (context) => RelatarproblemaPage(),
    anonymousReport: (context) => RelatoAnonimo(),
    map: (context) => MapPage(),
    issueStatus: (context) => StatusPage(),
  };
}
