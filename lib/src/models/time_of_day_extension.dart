import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  bool earlierThan(TimeOfDay other) {
    return hour < other.hour || ((hour == other.hour) && minute < other.minute);
  }

  bool laterThan(TimeOfDay other) {
    return hour > other.hour || ((hour == other.hour) && minute > other.minute);
  }

  bool same(TimeOfDay other) => hour == other.hour && minute == other.minute;

  int minuteFrom(TimeOfDay timePoint) {
    return (hour - timePoint.hour) * 60 + (minute - timePoint.minute);
  }

  int minuteUntil(TimeOfDay timePoint) {
    return (timePoint.hour - hour) * 60 + (timePoint.minute - minute);
  }

  bool inTheGap(TimeOfDay timePoint, int gap) {
    return hour == timePoint.hour &&
        (minute >= timePoint.minute && minute < (timePoint.minute + gap));
  }
}
