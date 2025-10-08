import 'package:flutter/material.dart';
import 'package:app_hackaton/app/routes.dart';
import 'package:app_hackaton/state/app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = AppState().selectedCity;
  String flag = AppState().selectedFlag;

  final cities = [
    {'name': 'concordia', 'flag': 'assets/flags/concordia.png'},
    {'name': 'seara', 'flag': 'assets/flags/seara.png'},
    {'name': 'ipumirim', 'flag': 'assets/flags/ipumirim.png'},
    {'name': 'arabuta', 'flag': 'assets/flags/arabuta.png'},
    {'name': 'irani', 'flag': 'assets/flags/irani.png'},
    {'name': 'xanxere', 'flag': 'assets/flags/xanxere.png'},
    {'name': 'chapeco', 'flag': 'assets/flags/chapeco.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Urban Issue Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        leading: PopupMenuButton<Map<String, String>>(
          tooltip: 'Selecionar cidade',
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(4)),
              const SizedBox(width: 4),
              FittedBox(
                child: Image.asset(
                  'assets/flags/$city.png',
                  width: 25,
                  height: 25,
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            ],
          ),
          onSelected: (cityItem) {
            setState(() {
              city = cityItem['name']!;
              AppState().selectedCity = city;
              AppState().selectedFlag = flag;
            });
          },
          itemBuilder: (context) => cities.map((cityItem) {
            return PopupMenuItem<Map<String, String>>(
              value: cityItem,
              child: Text(cityItem['name']!),
            );
          }).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: Colors.black87,
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                Text(
                  city,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Botões
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.reportIssue),
              icon: const Icon(Icons.report_problem_outlined),
              label: const Text('Report Issue'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.anonymousReport),
              icon: const Icon(Icons.visibility_off_outlined),
              label: const Text('Anonymous Report'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.map),
              icon: const Icon(Icons.map_outlined),
              label: const Text('See Map'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.issueStatus),
              icon: const Icon(Icons.list_alt_outlined),
              label: const Text('Status of Issues'),
            ),
          ],
        ),
      ),
    );
  }
}
