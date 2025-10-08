import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../state/app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = AppState().selectedCity;
  String flag = AppState().selectedFlag;

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
        leading: IconButton(
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              flag,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
          tooltip: 'Select City',
          onPressed: () async {
            // Navigate and wait for return
            await Navigator.pushNamed(context, AppRoutes.selectCity);
            // Refresh city and flag after return
            setState(() {
              city = AppState().selectedCity;
              flag = AppState().selectedFlag;
            });
          },
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
            Text(
              'Current city: $city',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Buttons
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