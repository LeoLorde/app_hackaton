import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_hackaton/data/local_storage.dart';
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

  void _loadIssues() {
    setState(() {
      _issues = LocalStorage.getIssues();
    });
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
        title: Text('Mapa - ${AppState().selectedCity}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIssues,
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
                  onTap: () {
                    bool expanded = false;

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return DraggableScrollableSheet(
                              expand: false,
                              // Minimizada: 0.12, expandida: 0.35 (menor que antes)
                              initialChildSize: expanded ? 0.35 : 0.12,
                              minChildSize: 0.12,
                              maxChildSize: 0.55,
                              builder: (context, scrollController) {
                                return GestureDetector(
                                  // qualquer clique na box minimizada expande
                                  onTap: () {
                                    setState(() {
                                      expanded = true;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.zero,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 10,
                                          offset: const Offset(0, -2),
                                        ),
                                      ],
                                    ),
                                    child: SingleChildScrollView(
                                      controller: scrollController,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Container(
                                                width: 40,
                                                height: 5,
                                                margin: const EdgeInsets.only(bottom: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[400],
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),

                                            // Conteúdo da box (título + imagem)
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  issue.type,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 6),
                                                if (issue.imagePath != null)
                                                  Image.file(
                                                    File(issue.imagePath!),
                                                    height: 90,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                              ],
                                            ),

                                            const SizedBox(height: 6),

                                            // Descrição só aparece quando expandida
                                            if (expanded) ...[
                                              Text(
                                                issue.description,
                                                style: const TextStyle(fontSize: 15),
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
                  child: Icon(
                    Icons.location_pin,
                    color: markerColor,
                    size: 40,
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
