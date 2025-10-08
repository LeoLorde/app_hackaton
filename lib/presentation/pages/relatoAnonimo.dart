import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Relate seu problema'),
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ExpansionTile(
              collapsedBackgroundColor: Colors.blue[700],
              backgroundColor: Colors.blue[50],
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text(
                'Tipo do problema',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              children: _problemas.map((problema) {
                return RadioListTile<String>(
                  title: Text(problema),
                  value: problema,
                  groupValue: _selectedProblem,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() {
                      _selectedProblem = value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            SizedBox(
              height: 120,
              child: TextField(
                controller: _descricaoController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: () async {
                try {
                  Position pos = await _pegarLocalizacao();
                  setState(() {
                    _localizacao = '${pos.latitude}, ${pos.longitude}';
                  });
                } catch (e) {
                  // se der erro (negou permissão, serviço desligado, etc)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao pegar localização: $e')),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _localizacao ?? 'Localização',
                        style: TextStyle(
                          fontSize: 16,
                          color: _localizacao == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _selecionarImagem(true),
                    child: const Text('Tire uma foto'),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selecionarImagem(false),
                    child: const Text(
                      '📎 ou coloque sua imagem',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  if (_imagem != null) ...[
                    const SizedBox(height: 10),
                    Image.file(_imagem!, height: 150, fit: BoxFit.cover),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Enviado! Problema: $_selectedProblem\n$_localizacao',
                    ),
                  ),
                );
              },
              child: const Text('Enviar', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
