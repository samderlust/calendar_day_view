import '../../calendar_day_view.dart';
import '../extensions/date_time_extension.dart';
import '../models/overflow_event.dart';

/// From List of DayEvent process them into multiple OverflowEventRow
///
/// where each row contains multiple DayEvent that happen overlap each other
/// in the time range of a row.

List<OverflowEventsRow<T>> processOverflowEvents<T extends Object>(
  List<DayEvent<T>> sortedEvents, {
  required DateTime startOfDay,
  required DateTime endOfDay,
  bool cropBottomEvents = false,
}) {
  if (sortedEvents.isEmpty) return [];

  final List<OverflowEventsRow<T>> rows = [];

  var currentRow = OverflowEventsRow<T>(
    events: [sortedEvents.first],
    start: sortedEvents.first.start.cleanSec(),
    end: sortedEvents.first.end!,
  );

  for (var i = 1; i < sortedEvents.length; i++) {
    final event = sortedEvents[i];

    // Skip events outside the day range
    if (event.start.isBefore(startOfDay) || event.start.isAfter(endOfDay)) {
      continue;
    }

    if (event.start.isBefore(currentRow.end)) {
      // Event overlaps with current row
      final newEnd = cropBottomEvents
          ? event.end!.isBefore(endOfDay)
              ? event.end!
              : endOfDay
          : event.end!;

      currentRow = currentRow.copyWith(
        events: [...currentRow.events, event],
        end: event.end!.isAfter(currentRow.end) ? newEnd : currentRow.end,
      );
    } else {
      // Start new row
      rows.add(currentRow);
      currentRow = OverflowEventsRow(
        events: [event],
        start: event.start.cleanSec(),
        end: event.end!,
      );
    }
  }

  rows.add(currentRow); // Add the last row
  return rows;
}
