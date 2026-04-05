import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';

class OverflowDayViewTab extends HookWidget {
  const OverflowDayViewTab({
    super.key,
    required this.events,
    this.onTimeTap,
    this.onAddEvent,
  });
  final List<DayEvent<String>> events;
  final Function(DateTime)? onTimeTap;
  final Function(DayEvent<String>)? onAddEvent;
  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final renderAsList = useState<bool>(true);
    final cropBottomEvents = useState<bool>(true);

    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: CalendarDayView.overflow(
            config: OverFlowDayViewConfig(
              currentDate: DateTime.now(),
              timeGap: timeGap.value,
              heightPerMin: 2,
              endOfDay: const TimeOfDay(hour: 20, minute: 0),
              startOfDay: const TimeOfDay(hour: 4, minute: 0),
              renderRowAsListView: renderAsList.value,
              showCurrentTimeLine: true,
              cropBottomEvents: cropBottomEvents.value,
              showMoreOnRowButton: true,
              time12: true,
              scrollToCurrentTime: true,
              decoration: DayViewDecoration(
                dividerColor: Colors.black,
                timeLabel: (context, time) => Text(
                  timeFormat.format(time),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTimeTap: (t) async {
              debugPrint('onTimeTap: $t');
              final newEvent = await showAddEventDialog(context, t);
              if (newEvent != null) {
                onAddEvent?.call(newEvent);
              }
            },
            events: UnmodifiableListView(events),
            overflowItemBuilder: (context, constraints, itemIndex, event) {
              return GestureDetector(
                key: ValueKey(event.hashCode),
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.value),
                          Text('start:${timeFormat.format(event.start)}'),
                          Text('end:${timeFormat.format(event.end!)}'),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 3, left: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  key: ValueKey(event.hashCode),
                  width: !renderAsList.value ? (constraints.minWidth) - 6 : size.width / 4 - 6,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: itemIndex % 2 == 0 ? colorScheme.tertiaryContainer : colorScheme.secondaryContainer,
                    border: Border.all(color: colorScheme.tertiary, width: .4),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      event.value,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: colorScheme.onSecondaryContainer),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const Text('Render: '),
              const SizedBox(width: 8),
              Expanded(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('List Row')),
                    ButtonSegment(value: false, label: Text('Fixed Row')),
                  ],
                  selected: {renderAsList.value},
                  onSelectionChanged: (v) => renderAsList.value = v.first,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const Text('Crop Bottom Events'),
              Switch(
                value: cropBottomEvents.value,
                onChanged: (v) => cropBottomEvents.value = v,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const Text('TimeGap: '),
              const SizedBox(width: 8),
              Expanded(
                child: SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 15, label: Text('15m')),
                    ButtonSegment(value: 20, label: Text('20m')),
                    ButtonSegment(value: 30, label: Text('30m')),
                    ButtonSegment(value: 60, label: Text('60m')),
                  ],
                  selected: {timeGap.value},
                  onSelectionChanged: (v) => timeGap.value = v.first,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<DayEvent<String>?> showAddEventDialog(BuildContext context, DateTime t) async {
  return await showDialog<DayEvent<String>>(
    context: context,
    builder: (context) {
      final newText = faker.conference.name();

      return AlertDialog(
        title: const Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              timeFormat.format(t),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newEvent = DayEvent(
                value: newText,
                start: t,
                end: t.add(
                  Duration(minutes: faker.randomGenerator.element([20, 140])),
                ),
              );
              Navigator.pop(context, newEvent);
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Cancel'),
          )
        ],
      );
    },
  );
}
