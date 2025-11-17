// Support chat message model
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final MessageType type;
  final String? userId;
  final String? chatId;

  const SupportMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.userId,
    this.chatId,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'content': content,
      'isFromUser': isFromUser,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name,
      'userId': userId,
      'chatId': chatId,
    };
  }

  // Create from Firestore document
  factory SupportMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return SupportMessage(
      id: doc.id,
      content: data['content'] as String,
      isFromUser: data['isFromUser'] as bool,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: MessageType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => MessageType.text,
      ),
      userId: data['userId'] as String?,
      chatId: data['chatId'] as String?,
    );
  }

  // CopyWith for UI updates
  SupportMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    MessageType? type,
    String? userId,
    String? chatId,
  }) {
    return SupportMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      chatId: chatId ?? this.chatId,
    );
  }
}

enum MessageType { text, faq }

// FAQ item model
class FaqItem {
  final String id;
  final String question;
  final String answer;
  final bool isExpanded;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

  FaqItem copyWith({
    String? id,
    String? question,
    String? answer,
    bool? isExpanded,
  }) {
    return FaqItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}
