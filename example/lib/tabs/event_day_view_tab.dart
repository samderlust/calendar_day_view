import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';

class EventDayViewTab extends StatelessWidget {
  const EventDayViewTab({
    Key? key,
    required this.events,
  }) : super(key: key);
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CalendarDayView.eventOnly(
      config: EventDayViewConfig(
        showHourly: true,
        currentDate: DateTime.now(),
        timeLabelBuilder: (context, time) => Text(
          timeFormat.format(time),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      events: events,
      eventDayViewItemBuilder: (context, index, event) {
        return HookBuilder(builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: index % 2 == 0 ? colorScheme.tertiaryContainer : colorScheme.secondaryContainer,
              border: Border.all(color: colorScheme.tertiary, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            height: 50,
            child: Center(
              child: Text(
                event.value,
                style: TextStyle(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
