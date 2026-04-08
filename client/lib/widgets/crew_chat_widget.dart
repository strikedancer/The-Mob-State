import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import '../services/auth_service.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../models/crew_message.dart';
import 'message_bubble.dart';
import '../utils/top_right_notification.dart';

class CrewChatWidget extends StatefulWidget {
  final int crewId;

  const CrewChatWidget({super.key, required this.crewId});

  @override
  State<CrewChatWidget> createState() => _CrewChatWidgetState();
}

class _CrewChatWidgetState extends State<CrewChatWidget> {
  final List<CrewMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  bool _sending = false;
  StreamSubscription? _eventSubscription;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupSSEListener();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _setupSSEListener() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final eventStreamService = eventProvider.eventStreamService;
    
    _eventSubscription = eventStreamService.eventStream.listen((event) {
      if (event['event'] == 'crew.message') {
        final params = event['params'] as Map<String, dynamic>;
        final crewId = params['crewId'] as int?;
        
        if (crewId != null && crewId == widget.crewId) {
          final messageId = params['messageId'] as int;
          
          // Check if message already exists (prevent duplicates)
          final messageExists = _messages.any((m) => m.id == messageId);
          if (messageExists) {
            return; // Skip duplicate
          }
          
          final message = CrewMessage(
            id: messageId,
            crewId: crewId,
            playerId: params['sender']['id'] as int,
            message: params['message'] as String,
            createdAt: params['createdAt'] as String,
            sender: MessageSender.fromJson(params['sender']),
          );
          
          setState(() {
            _messages.add(message);
          });
          
          _scrollToBottom();
        }
      } else if (event['event'] == 'crew.message_deleted') {
        final params = event['params'] as Map<String, dynamic>;
        final messageId = params['messageId'] as int?;
        
        if (messageId != null) {
          setState(() {
            _messages.removeWhere((m) => m.id == messageId);
          });
        }
      }
    });
  }

  Future<void> _loadMessages() async {
    setState(() => _loading = true);
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews/${widget.crewId}/messages?limit=100');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final messagesList = params['messages'] as List;
        
        setState(() {
          _messages.clear();
          _messages.addAll(
            messagesList.map((m) => CrewMessage.fromJson(m)).toList(),
          );
        });
        
        _scrollToBottom();
      }
    } catch (e) {
      print('Error loading messages: $e');
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('Fout bij laden berichten: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    
    if (message.isEmpty) return;
    
    if (message.length > 500) {
      showTopRightFromSnackBar(context, 
        const SnackBar(
          content: Text('Bericht te lang (max 500 karakters)'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _sending = true);
    
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${widget.crewId}/messages',
        {'message': message},
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final newMessage = CrewMessage.fromJson(params['message']);
        
        setState(() {
          _messages.add(newMessage);
          _messageController.clear();
        });
        
        _scrollToBottom();
      }
    } catch (e) {
      print('Error sending message: $e');
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('Fout bij verzenden: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _deleteMessage(int messageId) async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.delete('/crews/${widget.crewId}/messages/$messageId');

      if (response.statusCode == 200) {
        setState(() {
          _messages.removeWhere((m) => m.id == messageId);
        });
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('Kon bericht niet verwijderen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _confirmDeleteMessage(int messageId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Bericht verwijderen?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Dit bericht wordt permanent verwijderd.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Verwijderen',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      _deleteMessage(messageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentPlayerId = authProvider.currentPlayer?.id ?? 0;

    if (_loading && _messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF1F8B24),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nog geen berichten',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Stuur het eerste bericht naar je crew!',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isOwn = message.playerId == currentPlayerId;

                    return MessageBubble.fromCrewMessage(
                      message: message,
                      currentUserId: currentPlayerId,
                      onLongPress: isOwn
                        ? () => _confirmDeleteMessage(message.id)
                        : null,
                    );
                  },
                ),
        ),
        MessageInput(
          controller: _messageController,
          onSend: _sendMessage,
          enabled: !_sending,
        ),
      ],
    );
  }
}
