import 'package:calendar_day_view/calendar_day_view.dart';

class CategorizedDayEvent extends DayEvent {
  final String categoryId;
  CategorizedDayEvent({
    required this.categoryId,
    required super.value,
    required super.start,
    super.end,
    super.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategorizedDayEvent && other.categoryId == categoryId;
  }

  @override
  int get hashCode => categoryId.hashCode;
}

class EventCategory {
  final String id;
  final String name;
  EventCategory({
    required this.id,
    required this.name,
  });
}
