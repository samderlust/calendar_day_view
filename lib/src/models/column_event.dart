import 'day_event.dart';

/// Represents a [DayEvent] with its assigned column position in a multi-column layout.
///
/// When events overlap in time, they are split into side-by-side columns.
/// [column] is the 0-indexed column this event occupies.
/// [totalColumns] is the total number of columns in this event's overlap cluster.
class ColumnEvent<T extends Object> {
  final DayEvent<T> event;
  final int column;
  final int totalColumns;

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
