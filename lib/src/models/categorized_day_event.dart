import 'package:calendar_day_view/calendar_day_view.dart';

class CategorizedDayEvent<T extends Object> extends DayEvent<T> {
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
