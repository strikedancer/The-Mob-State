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

  bool _isSubmitting = false;
  String _category = 'bug';
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tr('Support Tickets', 'Support Tickets'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_tr('Nieuw ticket', 'New ticket'), style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    _tr(
                      'Vul je melding in. Reacties en eerder verzonden tickets worden niet meer in dit spelersscherm getoond.',
                      'Fill in your report. Replies and previously sent tickets are no longer shown in this player screen.',
                    ),
                  ),
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
        ],
      ),
    );
  }
}
