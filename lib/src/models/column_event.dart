import 'day_event.dart';

/// A [DayEvent] with its assigned column position in a multi-column layout.
///
/// When events overlap in time in [MultiColumnCalendarDayView], they are
/// distributed into side-by-side columns. Each [ColumnEvent] records the
/// 0-indexed [column] this event occupies and the [totalColumns] of its
/// overlap cluster — all events transitively overlapping with each other
/// share the same [totalColumns] value.
///
/// Custom [OverlapStrategy] implementations produce lists of [ColumnEvent]
/// to drive the layout.
class ColumnEvent<T extends Object> {
  /// The underlying event.
  final DayEvent<T> event;

  /// 0-indexed column this event occupies within its overlap cluster.
  final int column;

  /// Total number of columns in the overlap cluster this event belongs to.
  ///
  /// Used by the view to size each event as
  /// `eventColumnWidth / totalColumns`.
  final int totalColumns;

  /// Creates a [ColumnEvent].
  const ColumnEvent({
    required this.event,
    required this.column,
    required this.totalColumns,
  });

  @override
  String toString() => 'ColumnEvent(event: $event, column: $column, totalColumns: $totalColumns)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ColumnEvent<T> && other.event == event && other.column == column && other.totalColumns == totalColumns;
  }

  @override
  int get hashCode => event.hashCode ^ column.hashCode ^ totalColumns.hashCode;
}
