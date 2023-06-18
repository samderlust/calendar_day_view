import '../../calendar_day_view.dart';
import '../extensions/time_of_day_extension.dart';
import '../models/overflow_event.dart';

List<OverflowEventsRow<T>> processOverflowEvents<T extends Object>(
    List<DayEvent<T>> sortedEvents) {
  if (sortedEvents.isEmpty) return [];
  var start = sortedEvents.first.start;
  var end = sortedEvents.first.end!;
  final Map<DateTime, OverflowEventsRow<T>> oM = {};

  for (final event in sortedEvents) {
    if (event.start.earlierThan(end)) {
      oM.update(
        start,
        (value) => value.copyWith(events: [...value.events, event]),
        ifAbsent: () => OverflowEventsRow(
            events: [event], start: event.start, end: event.end!),
      );

      if (event.end!.laterThan(end)) {
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
