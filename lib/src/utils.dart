import 'package:calendar_day_view/src/overflow_event.dart';
import 'package:flutter/material.dart';

import '../calendar_day_view.dart';

List<OverflowEventsRow<T>> processOverflowEvents<T extends Object>(
    List<DayEvent<T>> sortedEvents) {
  if (sortedEvents.isEmpty) return [];
  var start = sortedEvents.first.start;
  var end = sortedEvents.first.end!;
  final Map<TimeOfDay, OverflowEventsRow<T>> oM = {};

  for (final event in sortedEvents) {
    if (lt(event.start, end)) {
      // oM[start] = [...(oM[start] ?? []), event];
      oM.update(
        start,
        (value) => value.copyWith(events: [...value.events, event]),
        ifAbsent: () => OverflowEventsRow(
            events: [event], start: event.start, end: event.end!),
      );

      if (lt(end, event.end!)) {
        end = event.end!;
        oM[start] = oM[start]!.copyWith(end: event.end!);
      }
    } else {
      start = event.start;
      end = event.end!;
      oM[start] = OverflowEventsRow(
          events: [event], start: event.start, end: event.end!);
    }
  }
  return oM.values.toList();
}

bool le(TimeOfDay a, TimeOfDay b) {
  return a.hour < b.hour || ((a.hour == b.hour) && a.minute <= b.minute);
}

bool lt(TimeOfDay a, TimeOfDay b) {
  return a.hour < b.hour || ((a.hour == b.hour) && a.minute < b.minute);
}
