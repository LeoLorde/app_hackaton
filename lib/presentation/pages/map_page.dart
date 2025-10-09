import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_hackaton/db/issue_repository.dart';
import 'package:app_hackaton/db/database_helper.dart';
import 'package:app_hackaton/data/models/issue_model.dart';
import 'package:app_hackaton/state/app_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  List<Issue> _issues = [];
  late LatLng _initialCenter;
  final _issueRepo = IssueRepository();
  final _db = DatabaseHelper.instance;

  final List<String> _problemas = [
    'Buraco na estrada',
    'Falta de luz no poste',
    'Deslizamento',
    'Entulho de lixo',
    'Alagamento',
    'Risco de queda de árvore',
  ];

  @override
  void initState() {
    super.initState();
    final lat = AppState().cityLat ?? -27.2339;
    final lon = AppState().cityLon ?? -52.0278;
    _initialCenter = LatLng(lat, lon);
    _loadIssues();
  }

  void _loadIssues() async {
    try {
      final issues = await _issueRepo.getAllIssues();
      if (mounted) {
        setState(() {
          _issues = issues;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar problemas: $e')),
        );
      }
    }
  }

  Future<String?> _getReporterName(int? userId) async {
    if (userId == null) return null;
    
    try {
      final users = await _db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );
      
      if (users.isNotEmpty) {
        return users.first['name'] as String?;
      }
    } catch (e) {
      print('Error fetching reporter name: $e');
    }
    
    return null;
  }

  Color _getMarkerColor(String type) {
    switch (type) {
      case 'Buraco na estrada':
        return Colors.brown;
      case 'Falta de luz no poste':
        return const Color.fromARGB(255, 230, 226, 3);
      case 'Deslizamento':
        return Colors.orange;
      case 'Entulho de lixo':
        return Colors.green;
      case 'Alagamento':
        return Colors.blue;
      case 'Risco de queda de árvore':
        return Colors.teal;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa - ${AppState().selectedCity}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _loadIssues,
            ),
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: 13,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app_hackaton',
          ),
          MarkerLayer(
            markers: _issues.map((issue) {
              final markerColor = _getMarkerColor(issue.type);

              return Marker(
                point: LatLng(issue.latitude, issue.longitude),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () async {
                    bool expanded = false;
                    String? reporterName;
                    if (!issue.isAnonymous && issue.userId != null) {
                      reporterName = await _getReporterName(issue.userId);
                    }

                    if (!mounted) return;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: expanded ? 0.35 : 0.12,
                              minChildSize: 0.12,
                              maxChildSize: 0.55,
                              builder: (context, scrollController) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      expanded = true;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 20,
                                          offset: const Offset(0, -4),
                                        ),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 40,
                                                height: 5,
                                                margin: const EdgeInsets.only(bottom: 16),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  issue.type,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (issue.isAnonymous) ...[
                                                  const SizedBox(height: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.visibility_off,
                                                          size: 14,
                                                          color: Colors.grey[700],
                                                        ),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          'Relato Anônimo',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey[700],
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ] else if (reporterName != null) ...[
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person_outline,
                                                        size: 16,
                                                        color: Colors.blue[700],
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        'Relatado por: $reporterName',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey[700],
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                const SizedBox(height: 12),
                                                if (issue.imagePath != null)
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(12),
                                                    child: Image.file(
                                                      File(issue.imagePath!),
                                                      height: 120,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            if (expanded) ...[
                                              Text(
                                                issue.description,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey[700],
                                                  height: 1.5,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: markerColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.location_pin,
                      color: markerColor,
                      size: 44,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
