import 'package:flutter/material.dart';

class DayEvent<T extends Object> {
  final T value;
  final TimeOfDay start;
  final TimeOfDay? end;
  final String? name;
  DayEvent({
    required this.value,
    required this.start,
    this.end,
    this.name,
  });

  DayEvent<T> copyWith({
    T? value,
    TimeOfDay? start,
    TimeOfDay? end,
    String? name,
  }) {
    return DayEvent<T>(
      value: value ?? this.value,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
    );
  }

  @override
  String toString() {
    return 'DayEvent(value: $value, start: $start, end: $end, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayEvent<T> &&
        other.value == value &&
        other.start == start &&
        other.end == end &&
        other.name == name;
  }

  @override
  int get hashCode {
    return value.hashCode ^ start.hashCode ^ end.hashCode ^ name.hashCode;
  }
}

extension DayEventExtension on DayEvent {
  int get durationInMins => end == null
      ? 30
      : (end!.hour - start.hour) * 60 + (end!.minute - start.minute);

  int get timeGapFromZero => start.hour * 60 + start.minute;
  int minutesFrom(TimeOfDay timePoint) =>
      (start.hour - timePoint.hour) * 60 + (start.minute - timePoint.minute);

  bool isInThisGap(TimeOfDay timePoint, int gap) {
    return start.hour == timePoint.hour &&
        (start.minute >= timePoint.minute &&
            start.minute < (timePoint.minute + gap));
  }

  bool startAt(TimeOfDay timePoint) =>
      start.hour == timePoint.hour && timePoint.minute == start.minute;

  int compare(DayEvent other) {
    if (start.hour > other.start.hour) return 1;
    if (start.hour == other.start.hour && start.minute > other.start.minute) {
      return 1;
    }
    return -1;
  }
}
