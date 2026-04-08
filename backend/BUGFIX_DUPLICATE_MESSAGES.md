# 🐛 Bug Fix: Dubbele Berichten

## Probleem
Elk verzonden bericht verscheen **2x** in het scherm:
- 2x "hoi" gestuurd → 4 berichten zichtbaar
- Error: "Font bij versturen" (typo van "Fout bij versturen")

## Oorzaak

### 1. Dubbele SSE Events
Backend stuurde 2 SSE events per bericht:
```typescript
// Event naar receiver
await worldEventService.createEvent('direct_message.received', {...}, receiverId);

// Event naar sender  
await worldEventService.createEvent('direct_message.received', {...}, senderId);
```

**Probleem**: Beide events hadden exact dezelfde data (messageId, senderId, receiverId), waardoor de SSE listener het bericht 2x toevoegde.

### 2. Response Status Code
Backend stuurde `201 Created` maar Flutter checkte alleen op `200 OK`, waardoor de error message verscheen.

## Oplossing

### ✅ Fix 1: Duplicate Check (ChatScreen)
```dart
final messageId = params['messageId'] as int;

// Check if message already exists (prevent duplicates)
final messageExists = _messages.any((m) => m.id == messageId);
if (messageExists) {
  return; // Skip duplicate
}

final message = DirectMessage(...);
setState(() {
  _messages.add(message);
});
```

### ✅ Fix 2: Status Code Check
```dart
if (response.statusCode == 201 || response.statusCode == 200) {
  _messageController.clear();
} else {
  final errorMessage = data['params']?['error'] ?? data['error'] ?? 'Fout bij versturen';
  throw Exception(errorMessage);
}
```

### ✅ Fix 3: Crew Chat Duplicate Check
Zelfde duplicate check toegepast op `CrewChatWidget`:
```dart
final messageId = params['messageId'] as int;

final messageExists = _messages.any((m) => m.id == messageId);
if (messageExists) {
  return; // Skip duplicate
}
```

### ✅ Fix 4: DirectMessagesScreen Debouncing
Toegevoegd debouncing om multiple reloads te voorkomen:
```dart
Future.delayed(const Duration(milliseconds: 500), () {
  if (mounted) {
    _loadConversations();
  }
});
```

## Gewijzigde Bestanden
- ✅ `client/lib/screens/chat_screen.dart`
- ✅ `client/lib/widgets/crew_chat_widget.dart`
- ✅ `client/lib/screens/direct_messages_screen.dart`

## Test
Nu werkt het correct:
- Elk bericht verschijnt 1x
- Geen error bij versturen
- Real-time updates blijven werken
