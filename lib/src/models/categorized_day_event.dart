import 'package:calendar_day_view/calendar_day_view.dart';

/// A [DayEvent] that belongs to a specific [EventCategory].
///
/// Used by [CategoryDayView] and [CategoryOverflowDayView] to place events
/// into category columns. The [categoryId] must match an
/// [EventCategory.id] in the list of categories passed to the view.
///
/// Example:
/// ```dart
/// final event = CategorizedDayEvent<String>(
///   categoryId: 'room-1',
///   value: 'Design review',
///   start: DateTime(2024, 1, 1, 14, 0),
///   end: DateTime(2024, 1, 1, 15, 0),
/// );
/// ```
class CategorizedDayEvent<T extends Object> extends DayEvent<T> {
  /// The id of the [EventCategory] this event belongs to.
  final String categoryId;

  /// Creates a categorized day event.
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

    return other is CategorizedDayEvent &&
        other.categoryId == categoryId &&
        other.value == value &&
        other.start == start &&
        other.end == end &&
        other.name == name;
  }

  @override
  int get hashCode => categoryId.hashCode ^ super.hashCode;
}
