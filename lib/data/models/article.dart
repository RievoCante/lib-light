// News article model
import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String id;
  final String title;
  final String preview;
  final DateTime timestamp;
  final String icon;
  final String content;

  const Article({
    required this.id,
    required this.title,
    required this.preview,
    required this.timestamp,
    this.icon = '📝',
    this.content = '',
  });

  Article copyWith({
    String? id,
    String? title,
    String? preview,
    DateTime? timestamp,
    String? icon,
    String? content,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      preview: preview ?? this.preview,
      timestamp: timestamp ?? this.timestamp,
      icon: icon ?? this.icon,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'preview': preview,
      'timestamp': timestamp.toIso8601String(),
      'icon': icon,
      'content': content,
    };
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      preview: json['preview'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      icon: json['icon'] as String? ?? '📝',
      content: json['content'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title, preview, timestamp, icon, content];
}
