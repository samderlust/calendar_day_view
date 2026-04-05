import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  bool same(DateTime other) => hour == other.hour && minute == other.minute;

  int minuteFrom(DateTime timePoint) {
    return (hour - timePoint.hour) * 60 + (minute - timePoint.minute);
  }

  int minuteUntil(DateTime timePoint) {
    return timePoint.cleanSec().difference(cleanSec()).inMinutes;
  }

  bool inTheGap(DateTime timePoint, int gap) {
    return hour == timePoint.hour && (minute >= timePoint.minute && minute < (timePoint.minute + gap));
  }

  DateTime copyTimeAndMinClean(TimeOfDay tod) => copyWith(
        hour: tod.hour,
        minute: tod.minute,
        second: 00,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime cleanSec() => copyWith(second: 00, millisecond: 0, microsecond: 0);
  DateTime hourOnly() => copyWith(minute: 00, second: 00, millisecond: 0, microsecond: 0);
  String get hourDisplay24 => "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, "0")}";
  String get hourDisplay12 => "${(hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}";
}
