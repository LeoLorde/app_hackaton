import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String? _selectedTipo;

  final List<String> _tiposProblema = [
    'Buraco na estrada',
    'Falta de luz no poste',
    'Deslizamento',
    'Entulho de lixo',
    'Alagamento',
    'Risco de queda de árvore',
  ];

  final List<Map<String, String>> _problemas = [
    {
      'tipo': 'Deslizamento',
      'localizacao': 'Rua A, 123',
      'status': 'Não resolvido',
    },
    {
      'tipo': 'Deslizamento',
      'localizacao': 'Rua B, 456',
      'status': 'Em análise',
    },
    {
      'tipo': 'Deslizamento',
      'localizacao': 'Rua C, 789',
      'status': 'Resolvido',
    },
    {
      'tipo': 'Deslizamento',
      'localizacao': 'Rua D, 321',
      'status': 'Em andamento',
    },
    {
      'tipo': 'Buraco na estrada',
      'localizacao': 'Rua E, 654',
      'status': 'Não resolvido',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Não resolvido':
        return Colors.red;
      case 'Em análise':
        return Colors.grey;
      case 'Em andamento':
        return Colors.yellow;
      case 'Resolvido':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> problemasFiltrados = _selectedTipo == null
        ? _problemas
        : _problemas.where((p) => p['tipo'] == _selectedTipo).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status dos Problemas'),
        backgroundColor: Colors.grey[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown para filtrar por tipo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.blue[700],
                value: _selectedTipo,
                hint: const Text(
                  'Tipo do problema',
                  style: TextStyle(color: Colors.white),
                ),
                iconEnabledColor: Colors.white,
                underline: const SizedBox(),
                items: _tiposProblema.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(
                      tipo,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTipo = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Lista de problemas filtrados
            Expanded(
              child: ListView.builder(
                itemCount: problemasFiltrados.length,
                itemBuilder: (context, index) {
                  final problema = problemasFiltrados[index];
                  return Card(
                    color: Colors.blue[100],
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(problema['localizacao']!),
                      subtitle: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: _statusColor(problema['status']!),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(problema['status']!),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Função de excluir
                            },
                            child: const Text(
                              'Excluir',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              // Função de editar
                            },
                            child: const Text(
                              'Editar',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
