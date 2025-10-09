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
  String? _errorMessage;

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
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final issues = await _issueRepo.getAllIssues().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tempo esgotado ao carregar problemas');
        },
      );
      
      if (mounted) {
        setState(() {
          _issues = issues;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erro ao carregar: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar problemas: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Tentar novamente',
              textColor: Colors.white,
              onPressed: _loadIssues,
            ),
          ),
        );
      }
    }
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
                  try {
                    await _issueRepo.updateIssueStatus(issue.id!, newStatus!);
                    await _loadIssues();
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Status atualizado!')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao atualizar: $e')),
                      );
                    }
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
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Status dos Problemas',
          style: TextStyle(fontWeight: FontWeight.w600),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadIssues,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar novamente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue[700],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          dropdownColor: Colors.blue[700],
                          value: _selectedTipo,
                          hint: const Text(
                            'Filtrar por tipo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          iconEnabledColor: Colors.white,
                          underline: const SizedBox(),
                          items: _tiposProblema.map((tipo) {
                            return DropdownMenuItem(
                              value: tipo,
                              child: Text(
                                tipo,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
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
                      const SizedBox(height: 20),

                      Expanded(
                        child: problemasFiltrados.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inbox_outlined,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum problema encontrado',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: problemasFiltrados.length,
                                itemBuilder: (context, index) {
                                  final issue = problemasFiltrados[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  issue.type,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                              if (issue.isAnonymous)
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
                                                        'Anônimo',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey[700],
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            issue.description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _statusColor(issue.status).withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: _statusColor(issue.status).withOpacity(0.3),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: _statusColor(issue.status),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _statusLabel(issue.status),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: _statusColor(issue.status),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TextButton.icon(
                                                onPressed: () async {
                                                  final confirm = await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) => AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      title: const Text('Confirmar exclusão'),
                                                      content: const Text(
                                                        'Deseja realmente excluir este problema?',
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
                                                          style: TextButton.styleFrom(
                                                            foregroundColor: Colors.red,
                                                          ),
                                                          child: const Text('Excluir'),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                  if (confirm == true && issue.id != null) {
                                                    try {
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
                                                    } catch (e) {
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text('Erro ao excluir: $e'),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                                icon: const Icon(Icons.delete_outline, size: 18),
                                                label: const Text('Excluir'),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.red[600],
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              TextButton.icon(
                                                onPressed: () => _showEditStatusDialog(issue),
                                                icon: const Icon(Icons.edit_outlined, size: 18),
                                                label: const Text('Editar Status'),
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.blue[700],
                                                ),
                                              ),
                                            ],
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
