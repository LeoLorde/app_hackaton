import 'package:flutter/material.dart';
import '../../../state/app_state.dart';

class CitySelectPage extends StatelessWidget {
  const CitySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cities = [
      {'name': 'Concórdia', 'flag': 'assets/flags/concordia.png'},
      {'name': 'Seara', 'flag': 'assets/flags/seara.png'},
      {'name': 'Ipumirim', 'flag': 'assets/flags/ipumirim.png'},
      {'name': 'Arabutã', 'flag': 'assets/flags/arabuta.png'},
      {'name': 'Irani', 'flag': 'assets/flags/irani.png'},
      {'name': 'Xanxerê', 'flag': 'assets/flags/xanxere.png'},
      {'name': 'Chapecó', 'flag': 'assets/flags/chapeco.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your City'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          final city = cities[index];
          return ListTile(
            leading: Image.asset(
              city['flag']!,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
            title: Text(city['name']!),
            onTap: () {
              // Update shared app state
              AppState().selectedCity = city['name']!;
              AppState().selectedFlag = city['flag']!;

              // Go back to HomePage
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}