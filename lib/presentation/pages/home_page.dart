import 'package:flutter/material.dart';
import 'package:app_hackaton/app/routes.dart';
import 'package:app_hackaton/state/app_state.dart';
import 'package:app_hackaton/db/user_repository.dart';
import 'package:app_hackaton/data/city_coordinates.dart';

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
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        leadingWidth: 120,
        leading: PopupMenuButton<Map<String, String>>(
          tooltip: 'Selecionar cidade',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      flag,
                      width: 44,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black87,
                  size: 20,
                ),
              ],
            ),
          ),
          onSelected: (cityItem) {
            setState(() {
              city = cityItem['name']!;
              flag = cityItem['flag']!;

              final coords = CityCoordinates.getCoordinates(city);
              AppState().selectedCity = city;
              AppState().selectedFlag = flag;
              AppState().cityLat = coords['lat'];
              AppState().cityLon = coords['lon'];
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
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.person_outline),
              color: Colors.black87,
              tooltip: 'Profile',
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final userRepo = UserRepository();
                final isAuth = await userRepo.isAuthenticated();

                if (isAuth) {
                  Navigator.pushNamed(context, AppRoutes.profile);
                } else {
                  Navigator.pushNamed(context, AppRoutes.register);
                }
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset('assets/images/logo.png'),
            ),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.blue[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    city,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                _buildStyledButton(
                  context,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.reportIssue),
                  icon: Icons.report_problem_outlined,
                  label: 'Relatar Problema',
                  color: Colors.blue[700]!,
                ),
                const SizedBox(height: 14),
                _buildStyledButton(
                  context,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.anonymousReport),
                  icon: Icons.visibility_off_outlined,
                  label: 'Relatar Problema Anônimo',
                  color: Colors.blue[600]!,
                ),
                const SizedBox(height: 14),
                _buildStyledButton(
                  context,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.map),
                  icon: Icons.map_outlined,
                  label: 'Ver Mapa',
                  color: Colors.blue[700]!,
                ),
                const SizedBox(height: 14),
                _buildStyledButton(
                  context,
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.issueStatus),
                  icon: Icons.list_alt_outlined,
                  label: 'Status dos Problemas',
                  color: Colors.blue[600]!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
