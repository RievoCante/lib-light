// Support chat message model
class SupportMessage {
  final String id;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final MessageType type;

  const SupportMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.type = MessageType.text,
  });
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
