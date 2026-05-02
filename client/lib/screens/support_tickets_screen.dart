import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/support_badge_state.dart';
import '../utils/top_right_notification.dart';

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

/// Source module values sent to the API (order matches former dropdown).
const List<String> _kSupportModuleValues = [
  'support',
  'dashboard',
  'messages',
  'notifications',
  'payments',
  'bank',
  'crypto',
  'travel',
  'properties',
  'inventory',
  'loadouts',
  'crimes',
  'jobs',
  'vehicles',
  'garage',
  'marina',
  'aviation',
  'smuggling',
  'drugs',
  'nightclub',
  'prostitution',
  'crew',
  'friends',
  'hitlist',
  'security',
  'prison',
  'casino',
  'school',
  'achievements',
  'profile',
  'settings',
  'events',
  'other',
];

String _supportModuleLabel(AppLocalizations l10n, String value) {
  switch (value) {
    case 'support':
      return l10n.supportMod_support;
    case 'dashboard':
      return l10n.supportMod_dashboard;
    case 'messages':
      return l10n.supportMod_messages;
    case 'notifications':
      return l10n.supportMod_notifications;
    case 'payments':
      return l10n.supportMod_payments;
    case 'bank':
      return l10n.supportMod_bank;
    case 'crypto':
      return l10n.supportMod_crypto;
    case 'travel':
      return l10n.supportMod_travel;
    case 'properties':
      return l10n.supportMod_properties;
    case 'inventory':
      return l10n.supportMod_inventory;
    case 'loadouts':
      return l10n.supportMod_loadouts;
    case 'crimes':
      return l10n.supportMod_crimes;
    case 'jobs':
      return l10n.supportMod_jobs;
    case 'vehicles':
      return l10n.supportMod_vehicles;
    case 'garage':
      return l10n.supportMod_garage;
    case 'marina':
      return l10n.supportMod_marina;
    case 'aviation':
      return l10n.supportMod_aviation;
    case 'smuggling':
      return l10n.supportMod_smuggling;
    case 'drugs':
      return l10n.supportMod_drugs;
    case 'nightclub':
      return l10n.supportMod_nightclub;
    case 'prostitution':
      return l10n.supportMod_prostitution;
    case 'crew':
      return l10n.supportMod_crew;
    case 'friends':
      return l10n.supportMod_friends;
    case 'hitlist':
      return l10n.supportMod_hitlist;
    case 'security':
      return l10n.supportMod_security;
    case 'prison':
      return l10n.supportMod_prison;
    case 'casino':
      return l10n.supportMod_casino;
    case 'school':
      return l10n.supportMod_school;
    case 'achievements':
      return l10n.supportMod_achievements;
    case 'profile':
      return l10n.supportMod_profile;
    case 'settings':
      return l10n.supportMod_settings;
    case 'events':
      return l10n.supportMod_events;
    case 'other':
      return l10n.supportMod_other;
    default:
      return value;
  }
}

class SupportTicketsScreen extends StatefulWidget {
  /// When true (e.g. web dashboard panel), no [AppBar] — parent provides chrome.
  final bool embedded;

  const SupportTicketsScreen({
    super.key,
    this.embedded = false,
    this.onSeenSnapshotChanged,
  });

  final VoidCallback? onSeenSnapshotChanged;

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
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
        throw Exception(
          _extractErrorMessage(response.body, AppLocalizations.of(context)!),
        );
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
    } catch (e, st) {
      debugPrint('_loadTickets failed: $e\n$st');
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.supportLoadTicketsFailed),
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
        throw Exception(
          _extractErrorMessage(response.body, AppLocalizations.of(context)!),
        );
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
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${l10n.supportLoadTicketFailed}: $e',
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
    } catch (e, st) {
      debugPrint('_pickAttachment failed: $e\n$st');
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.supportPickImageFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _createTicket() async {
    final l10n = AppLocalizations.of(context)!;
    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();
    if (subject.length < 3 || message.length < 3) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.supportSubjectMessageMinLength,
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
            content: Text(l10n.supportTicketCreated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('_createTicket failed: $e\n$st');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.supportCreateTicketFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _sendReply() async {
    final l10n = AppLocalizations.of(context)!;
    final ticketId = _selectedTicketId;
    final message = _replyController.text.trim();
    if (ticketId == null || message.isEmpty) return;

    setState(() => _isSendingReply = true);
    try {
      final response = await _apiClient.post('/tickets/$ticketId/reply', {
        'message': message,
      });
      if (response.statusCode != 200) {
        throw Exception(
          _extractErrorMessage(response.body, AppLocalizations.of(context)!),
        );
      }

      _replyController.clear();
      await _loadTickets(preferredTicketId: ticketId);

      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.supportReplySent),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e, st) {
      debugPrint('_sendReply failed: $e\n$st');
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.supportReplySendFailed),
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
    final l10n = AppLocalizations.of(context)!;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            final dl10n = AppLocalizations.of(dialogContext)!;
            return AlertDialog(
            title: Text(dl10n.supportDeleteTicketTitle),
            content: Text(
              dl10n.supportDeleteTicketBody,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(dl10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(dl10n.delete),
              ),
            ],
          );
          },
        ) ??
        false;

    if (!confirmed) return;

    setState(() => _isDeletingTicket = true);
    try {
      final response = await _apiClient.delete('/tickets/$ticketId');
      if (response.statusCode != 200) {
        throw Exception(
          _extractErrorMessage(response.body, AppLocalizations.of(context)!),
        );
      }

      _replyController.clear();
      await _loadTickets();

      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.supportTicketDeleted),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            '${l10n.supportDeleteTicketFailed}: $e',
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

  String _extractErrorMessage(String body, AppLocalizations l10n) {
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
    return trimmed.isEmpty ? l10n.supportUnknownError : trimmed;
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'new':
        return l10n.supportStatusNew;
      case 'triage':
        return l10n.supportStatusTriage;
      case 'in_progress':
        return l10n.supportStatusInProgress;
      case 'waiting_player':
        return l10n.supportStatusWaitingPlayer;
      case 'blocked':
        return l10n.supportStatusBlocked;
      case 'resolved':
        return l10n.supportStatusResolved;
      case 'closed':
        return l10n.supportStatusClosed;
      case 'archived':
        return l10n.supportStatusArchived;
      default:
        return status;
    }
  }

  String _categoryLabel(AppLocalizations l10n, String category) {
    switch (category) {
      case 'bug':
        return l10n.supportCategoryBug;
      case 'question':
        return l10n.supportCategoryQuestion;
      case 'feedback':
        return l10n.supportCategoryFeedback;
      default:
        return l10n.supportCategoryOther;
    }
  }

  String _priorityLabel(AppLocalizations l10n, String priority) {
    switch (priority) {
      case 'low':
        return l10n.supportPriorityLow;
      case 'high':
        return l10n.supportPriorityHigh;
      case 'urgent':
        return l10n.supportPriorityUrgent;
      default:
        return l10n.supportPriorityNormal;
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

  String _formatRelative(AppLocalizations l10n, DateTime value) {
    final difference = DateTime.now().difference(value);
    if (difference.inDays >= 1) {
      return l10n.supportTimeDaysAgo(difference.inDays);
    }
    if (difference.inHours >= 1) {
      return l10n.supportTimeHoursAgo(difference.inHours);
    }
    if (difference.inMinutes >= 1) {
      return l10n.supportTimeMinutesAgo(difference.inMinutes);
    }
    return l10n.supportTimeJustNow;
  }

  String _senderLabel(AppLocalizations l10n, String senderType) {
    return senderType == 'admin'
        ? l10n.supportSenderSupport
        : l10n.supportSenderYou;
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
      builder: (dialogContext) {
        final dl10n = AppLocalizations.of(dialogContext)!;
        return Dialog(
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
                  errorBuilder: (_, _, _) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      dl10n.supportImageLoadFailed,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      },
    );
  }

  Widget _buildTicketListCard() {
    final l10n = AppLocalizations.of(context)!;
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
                    l10n.supportMyTickets,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(l10n.supportTicketsCountInList(_tickets.length.toString())),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.supportMyTicketsIntro,
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
                  l10n.supportNoTicketsYet,
                  style: const TextStyle(color: Color(0xFFF2E6DF)),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _tickets.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
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
                      '${_categoryLabel(l10n, ticket.category)} • ${_statusLabel(l10n, ticket.status)} • ${_formatRelative(l10n, ticket.updatedAt)}',
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
                            _statusLabel(l10n, ticket.status),
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
                              l10n.supportLastMessagePrefix +
                                  _senderLabel(l10n, ticket.lastMessageBy!),
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
    final l10n = AppLocalizations.of(context)!;
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
                l10n.supportSelectTicketPrompt,
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
                                      l10n,
                                      _selectedTicketDetail!.ticket.status,
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    _categoryLabel(
                                      l10n,
                                      _selectedTicketDetail!.ticket.category,
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    _priorityLabel(
                                      l10n,
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
                                      _supportModuleLabel(
                                        l10n,
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
                                '${l10n.supportReferenceLabel}: ${_selectedTicketDetail!.ticket.referenceCode}',
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
                        tooltip: l10n.supportDeleteTicketTitle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.supportConversation,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  if (_selectedTicketDetail!.messages.isEmpty)
                    Text(l10n.supportNoMessagesYet)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _selectedTicketDetail!.messages.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
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
                                        _senderLabel(l10n, message.senderType),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _formatRelative(l10n, message.createdAt),
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
                      l10n.supportAttachments,
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
                                    errorBuilder: (_, _, _) => Container(
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
                    l10n.supportReplyToTicket,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.supportReplyFieldHint,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _replyController,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      labelText: l10n.supportYourReply,
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
                      label: Text(l10n.supportSendReply),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(title: Text(l10n.supportTicketsScreenTitle)),
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
                      l10n.supportNewTicket,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.supportNewTicketIntro,
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
                              l10n.supportTicketReceivedBanner,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.supportTicketNumberLine(_lastCreatedTicketId!),
                            ),
                            Text(
                              l10n.supportTicketReceivedDetail,
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
                          child: Text(l10n.supportCategoryBug),
                        ),
                        DropdownMenuItem(
                          value: 'question',
                          child: Text(l10n.supportCategoryQuestion),
                        ),
                        DropdownMenuItem(
                          value: 'feedback',
                          child: Text(l10n.supportCategoryFeedback),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text(l10n.supportCategoryOther),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _category = value);
                      },
                      decoration: InputDecoration(
                        labelText: l10n.supportFieldCategory,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _sourceModule,
                      items: _kSupportModuleValues
                          .map(
                            (value) => DropdownMenuItem(
                              value: value,
                              child: Text(_supportModuleLabel(l10n, value)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _sourceModule = value);
                      },
                      decoration: InputDecoration(
                        labelText: l10n.supportFieldModule,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        labelText: l10n.supportFieldSubject,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _messageController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: l10n.supportFieldMessage,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _referenceController,
                      decoration: InputDecoration(
                        labelText: l10n.supportReferenceOptional,
                        hintText: l10n.supportReferenceHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _isSubmitting ? null : _pickAttachment,
                          icon: const Icon(Icons.image_outlined),
                          label: Text(
                            l10n.supportAddScreenshot,
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
                        label: Text(l10n.supportSubmit),
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
