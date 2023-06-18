import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  bool earlierThan(DateTime other) {
    return isBefore(other);
    return hour < other.hour || ((hour == other.hour) && minute < other.minute);
  }

  bool laterThan(DateTime other) {
    return isAfter(other);
    return hour > other.hour || ((hour == other.hour) && minute > other.minute);
  }

  bool same(DateTime other) => hour == other.hour && minute == other.minute;

  int minuteFrom(DateTime timePoint) {
    return (hour - timePoint.hour) * 60 + (minute - timePoint.minute);
  }

  int minuteUntil(DateTime timePoint) {
    return timePoint.difference(this).inMinutes;
    return (timePoint.hour - hour) * 60 + (timePoint.minute - minute);
  }

  bool inTheGap(DateTime timePoint, int gap) {
    return hour == timePoint.hour &&
        (minute >= timePoint.minute && minute < (timePoint.minute + gap));
  }
}
