import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  final _apiClient = AuthService().apiClient;
  final _imagePicker = ImagePicker();

  bool _isSubmitting = false;
  String _category = 'bug';
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  Uint8List? _attachmentBytes;
  String? _attachmentName;
  String? _attachmentMimeType;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    try {
      final file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 2200,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) return;

      setState(() {
        _attachmentBytes = bytes;
        _attachmentName = file.name;
        _attachmentMimeType = file.mimeType ?? 'image/jpeg';
      });
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text('${_tr('Afbeelding kiezen mislukt', 'Failed to select image')}: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
      final token = await _apiClient.getToken();
      final request = http.MultipartRequest('POST', Uri.parse('${AppConfig.apiBaseUrl}/tickets'));
      request.fields['category'] = _category;
      request.fields['subject'] = subject;
      request.fields['message'] = message;

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      if (_attachmentBytes != null && _attachmentName != null) {
        final contentTypeParts = (_attachmentMimeType ?? 'image/jpeg').split('/');
        request.files.add(
          http.MultipartFile.fromBytes(
            'attachment',
            _attachmentBytes!,
            filename: _attachmentName,
            contentType: contentTypeParts.length == 2
                ? MediaType(contentTypeParts[0], contentTypeParts[1])
                : MediaType('image', 'jpeg'),
          ),
        );
      }

      final streamedResponse = await request.send().timeout(AppConfig.apiTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 201) {
        throw Exception(response.body);
      }

      _subjectController.clear();
      _messageController.clear();
      setState(() {
        _attachmentBytes = null;
        _attachmentName = null;
        _attachmentMimeType = null;
      });

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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isSubmitting ? null : _pickAttachment,
                        icon: const Icon(Icons.image_outlined),
                        label: Text(_tr('Screenshot toevoegen', 'Add screenshot')),
                      ),
                      if (_attachmentName != null) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _attachmentName!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: _isSubmitting
                              ? null
                              : () {
                                  setState(() {
                                    _attachmentBytes = null;
                                    _attachmentName = null;
                                    _attachmentMimeType = null;
                                  });
                                },
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ],
                  ),
                  if (_attachmentBytes != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _attachmentBytes!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
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
