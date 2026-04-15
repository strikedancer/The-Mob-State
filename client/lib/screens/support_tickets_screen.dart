import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_config.dart';
import '../services/auth_service.dart';
import '../utils/support_badge_state.dart';
import '../utils/top_right_notification.dart';

class _SupportModuleOption {
  const _SupportModuleOption(this.value, this.labelNl, this.labelEn);

  final String value;
  final String labelNl;
  final String labelEn;
}

class _SupportTicketSummary {
  const _SupportTicketSummary({
    required this.id,
    required this.category,
    required this.subject,
    required this.status,
    required this.priority,
    required this.updatedAt,
    required this.sourceModule,
    required this.referenceCode,
    required this.lastMessageBy,
  });

  final int id;
  final String category;
  final String subject;
  final String status;
  final String priority;
  final DateTime updatedAt;
  final String? sourceModule;
  final String? referenceCode;
  final String? lastMessageBy;

  factory _SupportTicketSummary.fromJson(Map<String, dynamic> json) {
    return _SupportTicketSummary(
      id: _asInt(json['id']),
      category: (json['category'] ?? 'other').toString(),
      subject: (json['subject'] ?? '').toString(),
      status: (json['status'] ?? 'new').toString(),
      priority: (json['priority'] ?? 'normal').toString(),
      updatedAt: _asDateTime(json['updatedAt']),
      sourceModule: json['sourceModule']?.toString(),
      referenceCode: json['referenceCode']?.toString(),
      lastMessageBy: json['lastMessageBy']?.toString(),
    );
  }
}

class _SupportTicketMessage {
  const _SupportTicketMessage({
    required this.id,
    required this.senderType,
    required this.messageType,
    required this.message,
    required this.createdAt,
  });

  final int id;
  final String senderType;
  final String messageType;
  final String message;
  final DateTime createdAt;

  factory _SupportTicketMessage.fromJson(Map<String, dynamic> json) {
    return _SupportTicketMessage(
      id: _asInt(json['id']),
      senderType: (json['senderType'] ?? 'player').toString(),
      messageType: (json['messageType'] ?? 'public_reply').toString(),
      message: (json['message'] ?? '').toString(),
      createdAt: _asDateTime(json['createdAt']),
    );
  }
}

class _SupportTicketAttachment {
  const _SupportTicketAttachment({
    required this.id,
    required this.originalName,
    required this.mimeType,
    required this.url,
    required this.createdAt,
  });

  final int id;
  final String originalName;
  final String mimeType;
  final String url;
  final DateTime createdAt;

  factory _SupportTicketAttachment.fromJson(Map<String, dynamic> json) {
    return _SupportTicketAttachment(
      id: _asInt(json['id']),
      originalName: (json['originalName'] ?? 'attachment').toString(),
      mimeType: (json['mimeType'] ?? 'image/jpeg').toString(),
      url: (json['url'] ?? '').toString(),
      createdAt: _asDateTime(json['createdAt']),
    );
  }
}

class _SupportTicketDetail {
  const _SupportTicketDetail({
    required this.ticket,
    required this.messages,
    required this.attachments,
  });

  final _SupportTicketSummary ticket;
  final List<_SupportTicketMessage> messages;
  final List<_SupportTicketAttachment> attachments;

  factory _SupportTicketDetail.fromJson(Map<String, dynamic> json) {
    final rawMessages = (json['messages'] as List<dynamic>? ?? const []);
    final rawAttachments = (json['attachments'] as List<dynamic>? ?? const []);

    return _SupportTicketDetail(
      ticket: _SupportTicketSummary.fromJson(
        (json['ticket'] as Map<String, dynamic>? ?? const {}),
      ),
      messages: rawMessages
          .map(
            (item) =>
                _SupportTicketMessage.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      attachments: rawAttachments
          .map(
            (item) =>
                _SupportTicketAttachment.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime _asDateTime(dynamic value) {
  final parsed = DateTime.tryParse(value?.toString() ?? '');
  return (parsed ?? DateTime.now()).toLocal();
}

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key, this.onSeenSnapshotChanged});

  final VoidCallback? onSeenSnapshotChanged;

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  static const List<_SupportModuleOption> _moduleOptions = [
    _SupportModuleOption('support', 'Algemeen support', 'General support'),
    _SupportModuleOption('dashboard', 'Dashboard', 'Dashboard'),
    _SupportModuleOption('messages', 'Berichten / inbox', 'Messages / inbox'),
    _SupportModuleOption(
      'notifications',
      'Meldingen / push',
      'Notifications / push',
    ),
    _SupportModuleOption(
      'payments',
      'Betalingen / premium',
      'Payments / premium',
    ),
    _SupportModuleOption('bank', 'Bank', 'Bank'),
    _SupportModuleOption('crypto', 'Crypto', 'Crypto'),
    _SupportModuleOption('travel', 'Reizen', 'Travel'),
    _SupportModuleOption('properties', 'Eigendommen', 'Properties'),
    _SupportModuleOption(
      'inventory',
      'Inventory / opslag',
      'Inventory / storage',
    ),
    _SupportModuleOption(
      'loadouts',
      'Loadouts / uitrusting',
      'Loadouts / equipment',
    ),
    _SupportModuleOption('crimes', 'Misdaden', 'Crimes'),
    _SupportModuleOption('jobs', 'Werk / banen', 'Work / jobs'),
    _SupportModuleOption(
      'vehicles',
      'Auto / motor / boot diefstal',
      'Car / bike / boat theft',
    ),
    _SupportModuleOption('garage', 'Garage', 'Garage'),
    _SupportModuleOption('marina', 'Marina', 'Marina'),
    _SupportModuleOption('aviation', 'Luchtvaart', 'Aviation'),
    _SupportModuleOption('smuggling', 'Smokkelen', 'Smuggling'),
    _SupportModuleOption('drugs', 'Drugs', 'Drugs'),
    _SupportModuleOption('nightclub', 'Nachtclub', 'Nightclub'),
    _SupportModuleOption('prostitution', 'Prostitutie', 'Prostitution'),
    _SupportModuleOption('crew', 'Crew', 'Crew'),
    _SupportModuleOption('friends', 'Vrienden / spelers', 'Friends / players'),
    _SupportModuleOption('hitlist', 'Hitlist', 'Hitlist'),
    _SupportModuleOption('security', 'Beveiliging / FBI', 'Security / FBI'),
    _SupportModuleOption('prison', 'Gevangenis / rechtbank', 'Prison / court'),
    _SupportModuleOption('casino', 'Casino', 'Casino'),
    _SupportModuleOption('school', 'School / training', 'School / training'),
    _SupportModuleOption('achievements', 'Achievements', 'Achievements'),
    _SupportModuleOption('profile', 'Profiel', 'Profile'),
    _SupportModuleOption('settings', 'Instellingen', 'Settings'),
    _SupportModuleOption(
      'events',
      'Events / leaderboard',
      'Events / leaderboard',
    ),
    _SupportModuleOption('other', 'Overig', 'Other'),
  ];

  final _apiClient = AuthService().apiClient;
  final _imagePicker = ImagePicker();

  bool _isSubmitting = false;
  bool _isLoadingTickets = true;
  bool _isLoadingDetail = false;
  bool _isSendingReply = false;
  bool _isDeletingTicket = false;
  String _category = 'bug';
  String _sourceModule = 'support';
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _referenceController = TextEditingController();
  final _replyController = TextEditingController();
  Uint8List? _attachmentBytes;
  String? _attachmentName;
  String? _attachmentMimeType;
  int? _lastCreatedTicketId;
  String? _authToken;
  int? _selectedTicketId;
  List<_SupportTicketSummary> _tickets = const [];
  _SupportTicketDetail? _selectedTicketDetail;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _referenceController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadTickets({int? preferredTicketId}) async {
    if (mounted) {
      setState(() => _isLoadingTickets = true);
    }

    try {
      final response = await _apiClient.get('/tickets/my');
      if (response.statusCode != 200) {
        throw Exception(_extractErrorMessage(response.body));
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final params = decoded['params'] as Map<String, dynamic>? ?? const {};
      final rawTickets = (params['tickets'] as List<dynamic>? ?? const []);
      final tickets = rawTickets
          .map(
            (item) =>
                _SupportTicketSummary.fromJson(item as Map<String, dynamic>),
          )
          .toList();
      final token = await _apiClient.getToken();

      int? nextSelectedId = preferredTicketId ?? _selectedTicketId;
      if (tickets.isEmpty) {
        nextSelectedId = null;
      } else if (nextSelectedId == null ||
          !tickets.any((ticket) => ticket.id == nextSelectedId)) {
        nextSelectedId = tickets.first.id;
      }

      if (!mounted) return;
      setState(() {
        _tickets = tickets;
        _authToken = token;
        _selectedTicketId = nextSelectedId;
        if (nextSelectedId == null) {
          _selectedTicketDetail = null;
        }
      });

      await _markTicketsAsSeen(tickets);

      if (nextSelectedId != null) {
        await _loadTicketDetail(nextSelectedId);
      }
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${_tr('Tickets laden mislukt', 'Failed to load tickets')}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingTickets = false);
      }
    }
  }

  Future<void> _markTicketsAsSeen(List<_SupportTicketSummary> tickets) async {
    final signatures = <int, String>{
      for (final ticket in tickets)
        ticket.id: buildSupportTicketSeenSignature(
          updatedAt: ticket.updatedAt,
          status: ticket.status,
          lastMessageBy: ticket.lastMessageBy,
        ),
    };

    await markSupportTicketSignaturesSeen(signatures);
    widget.onSeenSnapshotChanged?.call();
  }

  Future<void> _loadTicketDetail(int ticketId) async {
    if (mounted) {
      setState(() => _isLoadingDetail = true);
    }

    try {
      final response = await _apiClient.get('/tickets/$ticketId');
      if (response.statusCode != 200) {
        throw Exception(_extractErrorMessage(response.body));
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final params = decoded['params'] as Map<String, dynamic>? ?? const {};
      final detail = _SupportTicketDetail.fromJson(params);

      if (!mounted) return;
      setState(() {
        _selectedTicketId = ticketId;
        _selectedTicketDetail = detail;
      });
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${_tr('Ticket laden mislukt', 'Failed to load ticket')}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingDetail = false);
      }
    }
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
          content: Text(
            '${_tr('Afbeelding kiezen mislukt', 'Failed to select image')}: $e',
          ),
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
          content: Text(
            _tr(
              'Vul onderwerp en bericht in (min. 3 tekens).',
              'Fill in subject and message (min. 3 chars).',
            ),
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final token = await _apiClient.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AppConfig.apiBaseUrl}/tickets'),
      );
      request.fields['category'] = _category;
      request.fields['subject'] = subject;
      request.fields['message'] = message;
      request.fields['sourceModule'] = _sourceModule;
      request.fields['referenceCode'] = _referenceController.text.trim();
      request.fields['clientPlatform'] = defaultTargetPlatform.name;
      request.fields['appLocale'] = Localizations.localeOf(
        context,
      ).languageCode;

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      if (_attachmentBytes != null && _attachmentName != null) {
        final contentTypeParts = (_attachmentMimeType ?? 'image/jpeg').split(
          '/',
        );
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

      final streamedResponse = await request.send().timeout(
        AppConfig.apiTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 201) {
        throw Exception(response.body);
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final ticketId =
          (decoded['params'] as Map<String, dynamic>?)?['ticketId'] as int?;

      _subjectController.clear();
      _messageController.clear();
      _referenceController.clear();
      setState(() {
        _lastCreatedTicketId = ticketId;
        _attachmentBytes = null;
        _attachmentName = null;
        _attachmentMimeType = null;
      });

      await _loadTickets(preferredTicketId: ticketId);

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
            content: Text(
              '${_tr('Ticket aanmaken mislukt', 'Failed to create ticket')}: $e',
            ),
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
    final message = _replyController.text.trim();
    if (ticketId == null || message.length < 1) return;

    setState(() => _isSendingReply = true);
    try {
      final response = await _apiClient.post('/tickets/$ticketId/reply', {
        'message': message,
      });
      if (response.statusCode != 200) {
        throw Exception(_extractErrorMessage(response.body));
      }

      _replyController.clear();
      await _loadTickets(preferredTicketId: ticketId);

      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Reactie verstuurd.', 'Reply sent.')),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${_tr('Reactie versturen mislukt', 'Failed to send reply')}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSendingReply = false);
    }
  }

  Future<void> _deleteSelectedTicket() async {
    final ticketId = _selectedTicketId;
    if (ticketId == null || _isDeletingTicket) return;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(_tr('Ticket verwijderen', 'Delete ticket')),
            content: Text(
              _tr(
                'Weet je zeker dat je dit ticket wilt verwijderen? Deze actie kan niet ongedaan worden gemaakt.',
                'Are you sure you want to delete this ticket? This action cannot be undone.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(_tr('Annuleren', 'Cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(_tr('Verwijderen', 'Delete')),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    setState(() => _isDeletingTicket = true);
    try {
      final response = await _apiClient.delete('/tickets/$ticketId');
      if (response.statusCode != 200) {
        throw Exception(_extractErrorMessage(response.body));
      }

      _replyController.clear();
      await _loadTickets();

      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Ticket verwijderd.', 'Ticket deleted.')),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${_tr('Ticket verwijderen mislukt', 'Failed to delete ticket')}: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isDeletingTicket = false);
    }
  }

  Future<void> _refreshScreen() async {
    await _loadTickets(
      preferredTicketId: _selectedTicketId ?? _lastCreatedTicketId,
    );
  }

  String _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body) as Map<String, dynamic>;
      final params = decoded['params'];
      if (params is Map<String, dynamic>) {
        if (params['message'] != null) return params['message'].toString();
        if (params['error'] != null) return params['error'].toString();
      }
      if (decoded['event'] != null) return decoded['event'].toString();
    } catch (_) {
      // fall back to raw body
    }

    final trimmed = body.trim();
    return trimmed.isEmpty ? _tr('Onbekende fout', 'Unknown error') : trimmed;
  }

  String _moduleLabel(String value) {
    for (final option in _moduleOptions) {
      if (option.value == value) {
        return _tr(option.labelNl, option.labelEn);
      }
    }
    return value;
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'new':
        return _tr('Nieuw', 'New');
      case 'triage':
        return _tr('Triage', 'Triage');
      case 'in_progress':
        return _tr('In behandeling', 'In progress');
      case 'waiting_player':
        return _tr('Wacht op speler', 'Waiting for player');
      case 'blocked':
        return _tr('Geblokkeerd', 'Blocked');
      case 'resolved':
        return _tr('Opgelost', 'Resolved');
      case 'closed':
        return _tr('Gesloten', 'Closed');
      case 'archived':
        return _tr('Gearchiveerd', 'Archived');
      default:
        return status;
    }
  }

  String _categoryLabel(String category) {
    switch (category) {
      case 'bug':
        return _tr('Bug', 'Bug');
      case 'question':
        return _tr('Vraag', 'Question');
      case 'feedback':
        return _tr('Feedback', 'Feedback');
      default:
        return _tr('Overig', 'Other');
    }
  }

  String _priorityLabel(String priority) {
    switch (priority) {
      case 'low':
        return _tr('Laag', 'Low');
      case 'high':
        return _tr('Hoog', 'High');
      case 'urgent':
        return _tr('Urgent', 'Urgent');
      default:
        return _tr('Normaal', 'Normal');
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'waiting_player':
        return Colors.orange;
      case 'resolved':
      case 'closed':
        return Colors.green;
      case 'blocked':
        return Colors.red;
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatRelative(DateTime value) {
    final difference = DateTime.now().difference(value);
    if (difference.inDays >= 1) {
      return _tr('${difference.inDays}d geleden', '${difference.inDays}d ago');
    }
    if (difference.inHours >= 1) {
      return _tr(
        '${difference.inHours}u geleden',
        '${difference.inHours}h ago',
      );
    }
    if (difference.inMinutes >= 1) {
      return _tr(
        '${difference.inMinutes}m geleden',
        '${difference.inMinutes}m ago',
      );
    }
    return _tr('zojuist', 'just now');
  }

  String _senderLabel(String senderType) {
    return senderType == 'admin'
        ? _tr('Support', 'Support')
        : _tr('Jij', 'You');
  }

  String _attachmentUrl(_SupportTicketAttachment attachment) {
    return '${AppConfig.apiBaseUrl}${attachment.url}';
  }

  Map<String, String>? get _attachmentHeaders {
    if (_authToken == null || _authToken!.isEmpty) return null;
    return {'Authorization': 'Bearer $_authToken'};
  }

  void _openAttachmentPreview(_SupportTicketAttachment attachment) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      attachment.originalName,
                      style: Theme.of(dialogContext).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Flexible(
              child: InteractiveViewer(
                child: Image.network(
                  _attachmentUrl(attachment),
                  headers: _attachmentHeaders,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _tr('Afbeelding laden mislukt.', 'Failed to load image.'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketListCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _tr('Mijn tickets', 'My tickets'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('${_tickets.length}'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Support reageert voortaan rechtstreeks in dit scherm. Je kunt optioneel nog wel een pushmelding krijgen als er een update op je ticket is.',
                'Support now replies directly inside this screen. You can still optionally receive a push notification when your ticket gets an update.',
              ),
            ),
            const SizedBox(height: 12),
            if (_isLoadingTickets && _tickets.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_tickets.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A1F1C),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _tr(
                    'Je hebt nog geen tickets. Maak hieronder een nieuwe melding aan.',
                    'You do not have any tickets yet. Create a new report below.',
                  ),
                  style: const TextStyle(
                    color: Color(0xFFF2E6DF),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tickets.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final ticket = _tickets[index];
                  final selected = ticket.id == _selectedTicketId;
                  final color = _statusColor(ticket.status);
                  return ListTile(
                    selected: selected,
                    selectedTileColor: color.withValues(alpha: 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () => _loadTicketDetail(ticket.id),
                    title: Text('#${ticket.id} ${ticket.subject}'),
                    subtitle: Text(
                      '${_categoryLabel(ticket.category)} • ${_statusLabel(ticket.status)} • ${_formatRelative(ticket.updatedAt)}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _statusLabel(ticket.status),
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if ((ticket.lastMessageBy ?? '').isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              _tr('Laatste: ', 'Last: ') +
                                  _senderLabel(ticket.lastMessageBy!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTicketCard() {
    if (_selectedTicketId == null && _tickets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _isLoadingDetail && _selectedTicketDetail == null
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            : _selectedTicketDetail == null
            ? Text(
                _tr(
                  'Selecteer een ticket om het gesprek te openen.',
                  'Select a ticket to open the conversation.',
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '#${_selectedTicketDetail!.ticket.id} ${_selectedTicketDetail!.ticket.subject}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Chip(
                                  label: Text(
                                    _statusLabel(
                                      _selectedTicketDetail!.ticket.status,
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    _categoryLabel(
                                      _selectedTicketDetail!.ticket.category,
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    _priorityLabel(
                                      _selectedTicketDetail!.ticket.priority,
                                    ),
                                  ),
                                ),
                                if ((_selectedTicketDetail!
                                            .ticket
                                            .sourceModule ??
                                        '')
                                    .isNotEmpty)
                                  Chip(
                                    label: Text(
                                      _moduleLabel(
                                        _selectedTicketDetail!
                                            .ticket
                                            .sourceModule!,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            if ((_selectedTicketDetail!.ticket.referenceCode ??
                                    '')
                                .isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                _tr('Referentie', 'Reference') +
                                    ': ${_selectedTicketDetail!.ticket.referenceCode}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: _isDeletingTicket
                            ? null
                            : _deleteSelectedTicket,
                        icon: _isDeletingTicket
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.delete_outline),
                        tooltip: _tr('Ticket verwijderen', 'Delete ticket'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _tr('Gesprek', 'Conversation'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_selectedTicketDetail!.messages.isEmpty)
                    Text(_tr('Nog geen berichten.', 'No messages yet.'))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedTicketDetail!.messages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final message = _selectedTicketDetail!.messages[index];
                        final fromAdmin = message.senderType == 'admin';
                        final background = fromAdmin
                            ? const Color(0xFF2C313A)
                            : const Color(0xFF1F4A6A);
                        final borderColor = fromAdmin
                            ? Colors.white.withValues(alpha: 0.08)
                            : const Color(0xFF69B7FF).withValues(alpha: 0.28);
                        final primaryTextColor = Colors.white.withValues(
                          alpha: 0.96,
                        );
                        final secondaryTextColor = Colors.white.withValues(
                          alpha: 0.72,
                        );
                        final alignment = fromAdmin
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end;
                        return Column(
                          crossAxisAlignment: alignment,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: background,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _senderLabel(message.senderType),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _formatRelative(message.createdAt),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: secondaryTextColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    message.message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: primaryTextColor,
                                          height: 1.45,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  if (_selectedTicketDetail!.attachments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      _tr('Bijlagen', 'Attachments'),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _selectedTicketDetail!.attachments.map((
                        attachment,
                      ) {
                        return InkWell(
                          onTap: () => _openAttachmentPreview(attachment),
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 112,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    _attachmentUrl(attachment),
                                    headers: _attachmentHeaders,
                                    width: 112,
                                    height: 112,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 112,
                                      height: 112,
                                      color: Colors.grey.shade200,
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.image_not_supported_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  attachment.originalName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    _tr('Reageer op dit ticket', 'Reply to this ticket'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _tr(
                      'Gebruik dit veld als support meer informatie vraagt of als je een update wilt doorgeven. Inbox en push blijven alleen meldingen van nieuwe supportreacties.',
                      'Use this field when support asks for more information or when you want to provide an update. Inbox and push remain notification channels for new support replies.',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _replyController,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: _tr('Jouw reactie', 'Your reply'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _isSendingReply ? null : _sendReply,
                      icon: _isSendingReply
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.reply_outlined),
                      label: Text(_tr('Reactie versturen', 'Send reply')),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_tr('Support Tickets', 'Support Tickets'))),
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildTicketListCard(),
            const SizedBox(height: 12),
            _buildSelectedTicketCard(),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _tr('Nieuw ticket', 'New ticket'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _tr(
                        'Maak hier een nieuwe melding aan. Support kan daarna antwoorden via inbox/push en in dit scherm, zodat je het gesprek op 1 plek kunt voortzetten.',
                        'Create a new report here. Support can then reply through inbox/push and in this screen, so you can continue the conversation in one place.',
                      ),
                    ),
                    if (_lastCreatedTicketId != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tr('Ticket ontvangen', 'Ticket received'),
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _tr('Ticketnummer', 'Ticket number') +
                                  ': #$_lastCreatedTicketId',
                            ),
                            Text(
                              _tr(
                                'Het ticket staat nu direct bovenin je lijst. Nieuwe supportreacties komen ook als inboxbericht en pushmelding binnen.',
                                'The ticket now appears directly in your list above. New support replies also arrive as inbox messages and push notifications.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _category,
                      items: [
                        DropdownMenuItem(
                          value: 'bug',
                          child: Text(_tr('Bug', 'Bug')),
                        ),
                        DropdownMenuItem(
                          value: 'question',
                          child: Text(_tr('Vraag', 'Question')),
                        ),
                        DropdownMenuItem(
                          value: 'feedback',
                          child: Text(_tr('Feedback', 'Feedback')),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(_tr('Overig', 'Other')),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _category = value);
                      },
                      decoration: InputDecoration(
                        labelText: _tr('Categorie', 'Category'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _sourceModule,
                      items: _moduleOptions
                          .map(
                            (option) => DropdownMenuItem(
                              value: option.value,
                              child: Text(_tr(option.labelNl, option.labelEn)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _sourceModule = value);
                      },
                      decoration: InputDecoration(
                        labelText: _tr('Onderdeel', 'Module'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: _tr('Onderwerp', 'Subject'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: _tr('Bericht', 'Message'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _referenceController,
                      decoration: InputDecoration(
                        labelText: _tr(
                          'Referentie (optioneel)',
                          'Reference (optional)',
                        ),
                        hintText: _tr(
                          'Bijv. order-id, schermnaam, land of korte context',
                          'For example order id, screen name, country or short context',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSubmitting ? null : _pickAttachment,
                          icon: const Icon(Icons.image_outlined),
                          label: Text(
                            _tr('Screenshot toevoegen', 'Add screenshot'),
                          ),
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
      ),
    );
  }
}
