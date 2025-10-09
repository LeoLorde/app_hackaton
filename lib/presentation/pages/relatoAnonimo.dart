import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_hackaton/data/models/issue_model.dart';
import 'package:app_hackaton/db/issue_repository.dart';

class RelatoAnonimo extends StatefulWidget {
  const RelatoAnonimo({super.key});

  @override
  State<RelatoAnonimo> createState() => _RelatoAnonimoState();
}

class _RelatoAnonimoState extends State<RelatoAnonimo> {
  String? _selectedProblem;
  final TextEditingController _descricaoController = TextEditingController();
  String? _localizacao;
  File? _imagem;
  final _issueRepo = IssueRepository();

  final List<String> _problemas = [
    'Buraco na estrada',
    'Falta de luz no poste',
    'Deslizamento',
    'Entulho de lixo',
    'Alagamento',
    'Risco de queda de árvore',
  ];

  Future<Position> _pegarLocalizacao() async {
    // Verifica se o serviço de localização está ativado
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Serviço de localização está desativado');
    }

    // Verifica permissões
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permissão de localização negada');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada permanentemente');
    }

    // Pega a posição
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _selecionarImagem(bool camera) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(
      source: camera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (imagem != null) {
      setState(() {
        _imagem = File(imagem.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Relato Anônimo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Seu relato será enviado de forma anônima',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ExpansionTile(
                collapsedBackgroundColor: Colors.blue[700],
                backgroundColor: Colors.white,
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: const Text(
                  'Tipo do problema',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                children: _problemas.map((problema) {
                  return RadioListTile<String>(
                    title: Text(problema, style: const TextStyle(fontSize: 15)),
                    value: problema,
                    groupValue: _selectedProblem,
                    activeColor: Colors.blue[700],
                    onChanged: (value) {
                      setState(() {
                        _selectedProblem = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 130,
                child: TextField(
                  controller: _descricaoController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue[700]!,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                try {
                  Position pos = await _pegarLocalizacao();
                  setState(() {
                    _localizacao = '${pos.latitude}, ${pos.longitude}';
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao pegar localização: $e')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue[700], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _localizacao ?? 'Toque para obter localização',
                        style: TextStyle(
                          fontSize: 15,
                          color: _localizacao == null
                              ? Colors.grey[600]
                              : Colors.black87,
                          fontWeight: _localizacao == null
                              ? FontWeight.normal
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _selecionarImagem(true),
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: const Text(
                        'Tire uma foto',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_imagem != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _imagem!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  if (_selectedProblem == null || _localizacao == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, selecione o tipo e localização.',
                        ),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  final parts = _localizacao!.split(', ');
                  final issue = Issue(
                    type: _selectedProblem!,
                    description: _descricaoController.text,
                    latitude: double.parse(parts[0]),
                    longitude: double.parse(parts[1]),
                    imagePath: _imagem?.path,
                    userId: null,
                    isAnonymous: true,
                    status: 'pending',
                  );

                  await _issueRepo.insertIssue(issue);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Problema anônimo salvo com sucesso!',
                        ),
                        backgroundColor: Colors.green[600],
                      ),
                    );

                    _descricaoController.clear();
                    setState(() {
                      _selectedProblem = null;
                      _localizacao = null;
                      _imagem = null;
                    });
                  }
                },
                child: const Text(
                  'Enviar Anonimamente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
