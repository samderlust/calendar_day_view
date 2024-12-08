import '../extensions/date_time_extension.dart';

import '../../calendar_day_view.dart';
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

    if (event.start.earlierThan(currentRow.end)) {
      // Event overlaps with current row
      final newEnd = cropBottomEvents
          ? event.end!.isBefore(endOfDay)
              ? event.end!
              : endOfDay
          : event.end!;

      currentRow = currentRow.copyWith(
        events: [...currentRow.events, event],
        end: event.end!.laterThan(currentRow.end) ? newEnd : currentRow.end,
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

  // if (sortedEvents.isEmpty) return [];

  // var start = sortedEvents.first.start.cleanSec();
  // var end = sortedEvents.first.end!;

  // final Map<DateTime, OverflowEventsRow<T>> oM = {};

  // for (var event in sortedEvents) {
  //   if (event.start.isBefore(startOfDay) || event.start.isAfter(endOfDay)) {
  //     continue;
  //   }
  //   if (event.start.earlierThan(end)) {
  //     oM.update(
  //       start,
  //       (value) => value.copyWith(events: [...value.events, event]),
  //       ifAbsent: () => OverflowEventsRow(
  //           events: [event], start: event.start, end: event.end!),
  //     );

  //     if (event.end!.laterThan(end)) {
  //       if (cropBottomEvents) {
  //         end = event.end!.isBefore(endOfDay) ? event.end! : endOfDay;
  //       } else {
  //         end = event.end!;
  //       }
  //       oM[start] = oM[start]!.copyWith(end: end);
  //     }
  //   } else {
  //     start = event.start.cleanSec();
  //     end = event.end!;
  //     oM[start] = OverflowEventsRow(
  //         events: [event], start: event.start, end: event.end!);
  //   }
  // }

  // return oM.values.toList();
}
