// Calendar event model for corporate actions
import 'package:equatable/equatable.dart';

class CalendarEvent extends Equatable {
  final DateTime date;
  final String type;
  final List<String> stocks;
  final String description;

  const CalendarEvent({
    required this.date,
    required this.type,
    required this.stocks,
    required this.description,
  });

  CalendarEvent copyWith({
    DateTime? date,
    String? type,
    List<String>? stocks,
    String? description,
  }) {
    return CalendarEvent(
      date: date ?? this.date,
      type: type ?? this.type,
      stocks: stocks ?? this.stocks,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'type': type,
      'stocks': stocks,
      'description': description,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
      stocks: (json['stocks'] as List).cast<String>(),
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [date, type, stocks, description];
}
