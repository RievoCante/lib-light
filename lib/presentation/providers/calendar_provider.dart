// Calendar events provider
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/calendar_event.dart';
import '../../data/repositories/mock_data_repository.dart';

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, List<CalendarEvent>>((ref) {
      return CalendarNotifier();
    });

class CalendarNotifier extends StateNotifier<List<CalendarEvent>> {
  CalendarNotifier() : super(MockDataRepository.getMockCalendarEvents());

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return state.where((event) {
      return event.date.year == date.year &&
          event.date.month == date.month &&
          event.date.day == date.day;
    }).toList();
  }

  bool hasEventsOnDate(DateTime date) {
    return getEventsForDate(date).isNotEmpty;
  }

  List<DateTime> getEventDates() {
    return state.map((event) => event.date).toList();
  }
}
