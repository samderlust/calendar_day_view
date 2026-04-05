/// A generic event displayed in a calendar day view.
///
/// [T] is the type of the underlying [value] (e.g., `String`, a domain model,
/// or any `Object`). An event has a required [start] time; [end] is optional
/// — when null, the event is rendered with a default 30-minute duration.
///
/// Example:
/// ```dart
/// final meeting = DayEvent<String>(
///   value: 'Team sync',
///   start: DateTime(2024, 1, 1, 10, 0),
///   end: DateTime(2024, 1, 1, 10, 30),
///   name: 'weekly',
/// );
/// ```
class DayEvent<T extends Object> {
  /// The payload for this event (e.g., a title, id, or domain object).
  final T value;

  /// The moment the event starts. Required.
  final DateTime start;

  /// The moment the event ends. Optional — defaults to a 30-minute duration
  /// when null.
  ///
  /// Must be strictly after [start] when provided.
  final DateTime? end;

  /// An optional name/label for the event. This is metadata only — the view
  /// renders [value] through the builder; [name] is not displayed unless
  /// your builder uses it.
  final String? name;

  /// Creates a day event.
  ///
  /// Asserts that [end] is either null or strictly after [start].
  DayEvent({
    required this.value,
    required this.start,
    this.end,
    this.name,
  }) : assert(
          end == null || end.isAfter(start),
          'End can not be before start| start: $start |end: $end ',
        );

  /// Returns a copy of this event with the given fields replaced.
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

    return other is DayEvent<T> && other.value == value && other.start == start && other.end == end && other.name == name;
  }

  @override
  int get hashCode {
    return value.hashCode ^ start.hashCode ^ end.hashCode ^ name.hashCode;
  }
}

/// Time-based helpers on [DayEvent] used internally by the views.
///
/// These are exposed so users can reuse them in custom builders and
/// overlap strategies.
extension DayEventExtension on DayEvent {
  /// Duration of the event in minutes. Defaults to 30 when [DayEvent.end]
  /// is null.
  int get durationInMins => end == null ? 30 : end!.difference(start).inMinutes;

  /// Minutes from midnight to the event's [DayEvent.start].
  int get timeGapFromZero => start.hour * 60 + start.minute;

  /// Minutes from the event's [DayEvent.start] to [timePoint] (negative
  /// when [timePoint] is after the start).
  int minutesFrom(DateTime timePoint) => start.difference(timePoint).inMinutes;

  /// Whether this event is active during the gap that begins at [timePoint]
  /// and lasts [gap] minutes (either starts in it or is already running).
  bool isInThisGap(DateTime timePoint, int gap) {
    final dif = timePoint.copyWith(second: 00).difference(start.copyWith(second: 00)).inMinutes;
    return dif >= 0 && dif <= gap;
  }

  /// Whether this event's [DayEvent.start] falls strictly inside
  /// `[timePoint, timePoint + gap)`.
  bool startInThisGap(DateTime timePoint, int gap) {
    return (start.isAfter(timePoint) || start.isAtSameMomentAs(timePoint)) && start.isBefore(timePoint.add(Duration(minutes: gap)));
  }

  /// Whether this event's start matches [timePoint] at hour+minute
  /// granularity.
  bool startAt(DateTime timePoint) => start.hour == timePoint.hour && timePoint.minute == start.minute;

  /// Whether this event's start falls in the same hour as [timePoint].
  bool startAtHour(DateTime timePoint) => start.hour == timePoint.hour;

  /// Comparator by start time — returns -1 if this starts before [other],
  /// otherwise 1.
  int compare(DayEvent other) {
    return start.isBefore(other.start) ? -1 : 1;
  }
}
