import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';
import '../widgets/settings_sheet.dart';

class OverflowDayViewTab extends HookWidget {
  const OverflowDayViewTab({
    super.key,
    required this.events,
    this.onAddEvent,
  });
  final List<DayEvent<String>> events;
  final Function(DayEvent<String>)? onAddEvent;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final heightPerMin = useState<double>(2);
    final renderAsList = useState<bool>(true);
    final cropBottomEvents = useState<bool>(true);
    final showCurrentTimeLine = useState<bool>(true);
    final scrollToCurrentTime = useState<bool>(true);
    final showMoreOnRowButton = useState<bool>(true);
    final time12 = useState<bool>(true);
    final timeColumnPosition = useState<TimeColumnPosition>(TimeColumnPosition.left);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CalendarDayView.overflow(
        config: OverFlowDayViewConfig(
          currentDate: DateTime.now(),
          timeGap: timeGap.value,
          heightPerMin: heightPerMin.value,
          endOfDay: const TimeOfDay(hour: 20, minute: 0),
          startOfDay: const TimeOfDay(hour: 4, minute: 0),
          renderRowAsListView: renderAsList.value,
          showCurrentTimeLine: showCurrentTimeLine.value,
          cropBottomEvents: cropBottomEvents.value,
          showMoreOnRowButton: showMoreOnRowButton.value,
          time12: time12.value,
          scrollToCurrentTime: scrollToCurrentTime.value,
          decoration: DayViewDecoration(
            dividerColor: Colors.black,
            timeColumnPosition: timeColumnPosition.value,
            timeLabel: (context, time) => FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatTime(time, use12: time12.value),
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ),
          ),
        ),
        onTimeTap: (t) async {
          final newEvent = await showAddEventDialog(context, t);
          if (newEvent != null) {
            onAddEvent?.call(newEvent);
          }
        },
        events: UnmodifiableListView(events),
        overflowItemBuilder: (context, constraints, itemIndex, event) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${event.value} ${timeFormat.format(event.start)} - ${timeFormat.format(event.end!)}'),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: !renderAsList.value ? (constraints.minWidth) - 6 : MediaQuery.sizeOf(context).width / 4 - 6,
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
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'overflow-settings',
        onPressed: () => showSettingsSheet(
          context: context,
          title: 'Overflow Day View Settings',
          buildOptions: (setSheetState) => [
            SegmentSetting<int>(
              label: 'Time Gap',
              value: timeGap.value,
              options: const [15, 20, 30, 60],
              labels: const ['15m', '20m', '30m', '60m'],
              onChanged: (v) => setSheetState(() => timeGap.value = v),
            ),
            SegmentSetting<double>(
              label: 'Height Per Min',
              value: heightPerMin.value,
              options: const [0.5, 1.0, 1.5, 2.0],
              labels: const ['0.5x', '1x', '1.5x', '2x'],
              onChanged: (v) => setSheetState(() => heightPerMin.value = v),
            ),
            SegmentSetting<bool>(
              label: 'Render',
              value: renderAsList.value,
              options: const [true, false],
              labels: const ['List Row', 'Fixed Row'],
              onChanged: (v) => setSheetState(() => renderAsList.value = v),
            ),
            SegmentSetting<TimeColumnPosition>(
              label: 'Time Column Position',
              value: timeColumnPosition.value,
              options: TimeColumnPosition.values,
              labels: const ['Left', 'Right', 'None'],
              onChanged: (v) => setSheetState(() => timeColumnPosition.value = v),
            ),
            SwitchSetting(
              label: 'Crop Bottom Events',
              value: cropBottomEvents.value,
              onChanged: (v) => setSheetState(() => cropBottomEvents.value = v),
            ),
            SwitchSetting(
              label: 'Show Current Time Line',
              value: showCurrentTimeLine.value,
              onChanged: (v) => setSheetState(() => showCurrentTimeLine.value = v),
            ),
            SwitchSetting(
              label: 'Scroll To Current Time',
              value: scrollToCurrentTime.value,
              onChanged: (v) => setSheetState(() => scrollToCurrentTime.value = v),
            ),
            SwitchSetting(
              label: 'Show More On Row Button',
              value: showMoreOnRowButton.value,
              onChanged: (v) => setSheetState(() => showMoreOnRowButton.value = v),
            ),
            SwitchSetting(
              label: '12-hour format',
              value: time12.value,
              onChanged: (v) => setSheetState(() => time12.value = v),
            ),
          ],
        ),
        child: const Icon(Icons.tune),
      ),
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
            Text(newText, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(timeFormat.format(t), style: const TextStyle(fontWeight: FontWeight.bold)),
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
