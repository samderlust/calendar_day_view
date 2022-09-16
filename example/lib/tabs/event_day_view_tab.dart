import 'package:example/utils.dart';
import 'package:flutter/material.dart';

import 'package:calendar_day_view/calendar_day_view.dart';

class EventDayViewTab extends StatelessWidget {
  const EventDayViewTab({
    Key? key,
    required this.events,
  }) : super(key: key);
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    return EventCalendarDayView(
      events: events,
      eventDayViewItemBuilder: (context, event) {
        return Container(
          color: getRandomColor(),
          height: 50,
          child: Text(event.value),
        );
      },
    );
  }
}
