class DayEvent<T extends Object> {
  final T value;
  final DateTime start;
  final DateTime? end;
  final String? name;

  DayEvent({
    required this.value,
    required this.start,
    this.end,
    this.name,
  }) : assert(
          end == null || end.isAfter(start),
          "End can not be before start| start: $start |end: $end ",
        );

  DayEvent<T> copyWith({
    T? value,
    DateTime? start,
    DateTime? end,
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
  int get durationInMins => end == null ? 30 : end!.difference(start).inMinutes;

  int get timeGapFromZero => start.hour * 60 + start.minute;

  int minutesFrom(DateTime timePoint) => start.difference(timePoint).inMinutes;
  // (start.hour - timePoint.hour) * 60 + (start.minute - timePoint.minute);

  bool isInThisGap(DateTime timePoint, int gap) {
    final dif = timePoint
        .copyWith(second: 00)
        .difference(start.copyWith(second: 00))
        .inMinutes;
    return dif >= 0 && dif <= gap;
  }

  bool startInThisGap(DateTime timePoint, int gap) {
    return start.isAfter(timePoint) &&
        start.isBefore(timePoint.add(Duration(minutes: gap)));
  }

  bool startAt(DateTime timePoint) =>
      start.hour == timePoint.hour && timePoint.minute == start.minute;
  bool startAtHour(DateTime timePoint) => start.hour == timePoint.hour;

  int compare(DayEvent other) {
    return start.isBefore(other.start) ? -1 : 1;

    // if (start.hour > other.start.hour) return 1;
    // if (start.hour == other.start.hour && start.minute > other.start.minute) {
    //   return 1;
    // }
    // return -1;
  }
}
