import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';

class OverflowDayViewTab extends StatelessWidget {
  const OverflowDayViewTab({
    Key? key,
    required this.events,
  }) : super(key: key);
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    return OverFlowCalendarDayView(
      events: events,
    );
  }
}
