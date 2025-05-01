import 'package:flutter/material.dart';

import '../../../extensions/date_time_extension.dart';
import '../../../models/day_event.dart';
import '../../../models/overflow_event.dart';
import '../../../models/typedef.dart';

class OverflowFixedWidthEventsWidget<T extends Object> extends StatelessWidget {
  const OverflowFixedWidthEventsWidget({
    super.key,
    required this.overflowEvents,
    required this.heightUnit,
    required this.eventColumnWidth,
    required this.timeTitleColumnWidth,
    required this.overflowItemBuilder,
    required this.timeStart,
    required this.timeEnd,
    required this.cropBottomEvents,
  });

  final List<OverflowEventsRow<T>> overflowEvents;
  final double heightUnit;
  final double eventColumnWidth;
  final double timeTitleColumnWidth;
  final DayViewItemBuilder<T> overflowItemBuilder;
  final DateTime timeStart;
  final DateTime timeEnd;
  final bool cropBottomEvents;

  @override
  Widget build(BuildContext context) {
    final widgets = overflowEvents.expand((oEvents) {
      final maxHeight = (heightUnit * oEvents.start.minuteUntil(oEvents.end).abs());
      final width = eventColumnWidth / oEvents.events.length;

      return oEvents.events.asMap().entries.map((entry) {
        final i = entry.key;
        final event = entry.value;
        final topGap = event.minutesFrom(oEvents.start) * heightUnit;

        final tileHeight = (cropBottomEvents && event.end!.isAfter(timeEnd)) ? (maxHeight - topGap) : (event.durationInMins * heightUnit);

        final tileConstraints = BoxConstraints(
          maxHeight: tileHeight,
          minHeight: tileHeight,
          minWidth: width,
          maxWidth: eventColumnWidth,
        );

        return Positioned(
          left: timeTitleColumnWidth + i * width,
          top: event.minutesFrom(timeStart) * heightUnit,
          child: overflowItemBuilder(context, tileConstraints, i, event),
        );
      });
    }).toList();

    return Stack(
      clipBehavior: Clip.none,
      children: widgets,
    );
  }
}
