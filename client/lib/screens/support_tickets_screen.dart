import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final _apiClient = AuthService().apiClient;

  bool _isLoading = true;
  bool _isSubmitting = false;
  String _category = 'bug';
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _replyController = TextEditingController();

  List<Map<String, dynamic>> _tickets = [];
  int? _selectedTicketId;
  Map<String, dynamic>? _ticketDetail;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open':
        return _tr('Open', 'Open');
      case 'in_progress':
        return _tr('In behandeling', 'In progress');
      case 'waiting_player':
        return _tr('Wacht op speler', 'Waiting for player');
      case 'resolved':
        return _tr('Opgelost', 'Resolved');
      case 'closed':
        return _tr('Gesloten', 'Closed');
      default:
        return status;
    }
  }

  Future<void> _loadTickets() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/tickets/my');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = (data['params'] as Map<String, dynamic>?) ?? const {};
      final list = ((params['tickets'] as List?) ?? const [])
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList(growable: false);

      setState(() {
        _tickets = list;
        _isLoading = false;
      });

      if (_selectedTicketId == null && list.isNotEmpty) {
        await _loadTicketDetail((list.first['id'] as num).toInt());
      } else if (_selectedTicketId != null) {
        await _loadTicketDetail(_selectedTicketId!);
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout bij laden tickets', 'Error loading tickets')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadTicketDetail(int ticketId) async {
    try {
      final response = await _apiClient.get('/tickets/$ticketId');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final params = (data['params'] as Map<String, dynamic>?) ?? const {};
      setState(() {
        _selectedTicketId = ticketId;
        _ticketDetail = params;
      });
    } catch (_) {
      // keep previous state
    }
  }

  Future<void> _createTicket() async {
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    if (subject.length < 3 || message.length < 3) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Vul onderwerp en bericht in (min. 3 tekens).', 'Fill in subject and message (min. 3 chars).')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await _apiClient.post('/tickets', {
        'category': _category,
        'subject': subject,
        'message': message,
      });
      if (response.statusCode != 201) {
        throw Exception(response.body);
      }

      _subjectController.clear();
      _messageController.clear();
      await _loadTickets();

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_tr('Ticket aangemaakt.', 'Ticket created.')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Ticket aanmaken mislukt', 'Failed to create ticket')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _sendReply() async {
    final ticketId = _selectedTicketId;
    if (ticketId == null) return;
    final message = _replyController.text.trim();
    if (message.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final response = await _apiClient.post('/tickets/$ticketId/reply', {
        'message': message,
      });
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
      _replyController.clear();
      await _loadTickets();
      await _loadTicketDetail(ticketId);
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Antwoord verzenden mislukt', 'Failed to send reply')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _ticketDetail;
    final messages = ((detail?['messages'] as List?) ?? const [])
        .whereType<Map>()
        .map((e) => e.cast<String, dynamic>())
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Support Tickets', 'Support Tickets'))),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTickets,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_tr('Nieuw ticket', 'New ticket'), style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            value: _category,
                            items: [
                              DropdownMenuItem(value: 'bug', child: Text(_tr('Bug', 'Bug'))),
                              DropdownMenuItem(value: 'question', child: Text(_tr('Vraag', 'Question'))),
                              DropdownMenuItem(value: 'feedback', child: Text(_tr('Feedback', 'Feedback'))),
                              DropdownMenuItem(value: 'other', child: Text(_tr('Overig', 'Other'))),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _category = value);
                            },
                            decoration: InputDecoration(labelText: _tr('Categorie', 'Category')),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _subjectController,
                            decoration: InputDecoration(labelText: _tr('Onderwerp', 'Subject')),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _messageController,
                            minLines: 3,
                            maxLines: 6,
                            decoration: InputDecoration(labelText: _tr('Bericht', 'Message')),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: _isSubmitting ? null : _createTicket,
                              icon: const Icon(Icons.send),
                              label: Text(_tr('Versturen', 'Submit')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_tr('Mijn tickets', 'My tickets'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (_tickets.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_tr('Je hebt nog geen tickets.', 'You do not have any tickets yet.')),
                      ),
                    )
                  else
                    ..._tickets.map((ticket) {
                      final id = (ticket['id'] as num?)?.toInt() ?? 0;
                      final selected = id == _selectedTicketId;
                      return Card(
                        color: selected ? Theme.of(context).colorScheme.primary.withOpacity(0.14) : null,
                        child: ListTile(
                          onTap: () => _loadTicketDetail(id),
                          title: Text('#$id - ${ticket['subject'] ?? ''}'),
                          subtitle: Text('${_tr('Status', 'Status')}: ${_statusLabel(ticket['status']?.toString() ?? 'open')}'),
                          trailing: Text(ticket['category']?.toString() ?? ''),
                        ),
                      );
                    }),
                  if (detail != null) ...[
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_tr('Ticket', 'Ticket')} #${detail['ticket']?['id'] ?? ''} - ${detail['ticket']?['subject'] ?? ''}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ...messages.map((m) {
                              final senderType = (m['senderType'] ?? '').toString();
                              final isPlayer = senderType == 'player';
                              final label = isPlayer
                                  ? _tr('Jij', 'You')
                                  : senderType == 'admin'
                                      ? _tr('Support', 'Support')
                                      : _tr('Systeem', 'System');
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isPlayer
                                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.14)
                                      : Theme.of(context).colorScheme.primary.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(m['message']?.toString() ?? ''),
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _replyController,
                              minLines: 2,
                              maxLines: 5,
                              decoration: InputDecoration(labelText: _tr('Reageer op dit ticket', 'Reply to this ticket')),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton.icon(
                                onPressed: _isSubmitting ? null : _sendReply,
                                icon: const Icon(Icons.reply),
                                label: Text(_tr('Antwoord sturen', 'Send reply')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
