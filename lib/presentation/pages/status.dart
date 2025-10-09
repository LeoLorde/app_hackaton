import 'package:flutter/material.dart';
import 'package:app_hackaton/data/models/issue_model.dart';
import 'package:app_hackaton/db/issue_repository.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({super.key});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  String? _selectedTipo;
  List<Issue> _issues = [];
  final _issueRepo = IssueRepository();
  bool _isLoading = true;

  final List<String> _tiposProblema = [
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
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    setState(() => _isLoading = true);
    final issues = await _issueRepo.getAllIssues();
    setState(() {
      _issues = issues;
      _isLoading = false;
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.red;
      case 'under_analysis':
        return Colors.grey;
      case 'in_progress':
        return Colors.yellow;
      case 'resolved':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Não resolvido';
      case 'under_analysis':
        return 'Em análise';
      case 'in_progress':
        return 'Em andamento';
      case 'resolved':
        return 'Resolvido';
      default:
        return status;
    }
  }

  Future<void> _showEditStatusDialog(Issue issue) async {
    String? newStatus = issue.status;
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Status'),
          content: StatefulBuilder(
            builder: (context, setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Não resolvido'),
                    value: 'pending',
                    groupValue: newStatus,
                    onChanged: (value) {
                      setDialogState(() => newStatus = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Em análise'),
                    value: 'under_analysis',
                    groupValue: newStatus,
                    onChanged: (value) {
                      setDialogState(() => newStatus = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Em andamento'),
                    value: 'in_progress',
                    groupValue: newStatus,
                    onChanged: (value) {
                      setDialogState(() => newStatus = value);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Resolvido'),
                    value: 'resolved',
                    groupValue: newStatus,
                    onChanged: (value) {
                      setDialogState(() => newStatus = value);
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (newStatus != null && issue.id != null) {
                  await _issueRepo.updateIssueStatus(issue.id!, newStatus!);
                  await _loadIssues();
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Status atualizado!')),
                    );
                  }
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Issue> problemasFiltrados = _selectedTipo == null
        ? _issues
        : _issues.where((issue) => issue.type == _selectedTipo).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status dos Problemas'),
        backgroundColor: Colors.grey[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIssues,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
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

                  Expanded(
                    child: problemasFiltrados.isEmpty
                        ? const Center(
                            child: Text(
                              'Nenhum problema encontrado',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: problemasFiltrados.length,
                            itemBuilder: (context, index) {
                              final issue = problemasFiltrados[index];
                              return Card(
                                color: Colors.blue[100],
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(issue.type),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(issue.description),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 10,
                                            margin: const EdgeInsets.only(right: 8),
                                            decoration: BoxDecoration(
                                              color: _statusColor(issue.status),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Text(_statusLabel(issue.status)),
                                          if (issue.isAnonymous) ...[
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.visibility_off,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const Text(
                                              ' Anônimo',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Confirmar'),
                                              content: const Text(
                                                'Deseja excluir este problema?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, false),
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context, true),
                                                  child: const Text('Excluir'),
                                                ),
                                              ],
                                            ),
                                          );

                                          if (confirm == true && issue.id != null) {
                                            await _issueRepo.deleteIssue(issue.id!);
                                            await _loadIssues();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text('Problema excluído!'),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: const Text(
                                          'Excluir',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      TextButton(
                                        onPressed: () => _showEditStatusDialog(issue),
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
