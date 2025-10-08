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
    {'name': 'Concórdia', 'flag': 'assets/flags/concordia.jpg'},
    {'name': 'Seara', 'flag': 'assets/flags/seara.jpg'},
    {'name': 'Ipumirim', 'flag': 'assets/flags/ipumirim.jpg'},
    {'name': 'Arabutã', 'flag': 'assets/flags/arabuta.jpg'},
    {'name': 'Irani', 'flag': 'assets/flags/irani.jpg'},
    {'name': 'Xanxerê', 'flag': 'assets/flags/xanxere.jpg'},
    {'name': 'Chapecó', 'flag': 'assets/flags/chapeco.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 120,
        leading: PopupMenuButton<Map<String, String>>(
          tooltip: 'Selecionar cidade',
          child: SizedBox(
            width: 50,
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    flag,
                    width: 40,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black87,
                  size: 18,
                ),
              ],
            ),
          ),
          onSelected: (cityItem) {
            setState(() {
              city = cityItem['name']!;
              flag = cityItem['flag']!;
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
            color: Colors.black,
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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

            // Botões
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.reportIssue),
              icon: const Icon(Icons.report_problem_outlined),
              label: const Text('Relatar Problema'),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.anonymousReport),
              icon: const Icon(Icons.water_rounded),
              label: const Text('Relatar Problema Anônimo'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.map),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Ver Mapa'),
            ),
            ElevatedButton.icon(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.issueStatus),
              icon: const Icon(Icons.list_alt_outlined),
              label: const Text('Status dos Problemas'),
            ),
          ],
        ),
      ),
    );
  }
}
