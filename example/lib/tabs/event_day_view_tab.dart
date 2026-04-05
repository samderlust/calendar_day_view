import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';
import '../widgets/settings_sheet.dart';

class EventDayViewTab extends HookWidget {
  const EventDayViewTab({
    super.key,
    required this.events,
  });
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final showHourly = useState<bool>(true);
    final time12 = useState<bool>(false);
    final timeColumnPosition = useState<TimeColumnPosition>(TimeColumnPosition.left);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CalendarDayView.eventOnly(
        config: EventDayViewConfig(
          showHourly: showHourly.value,
          time12: time12.value,
          currentDate: DateTime.now(),
          decoration: DayViewDecoration(
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
        events: events,
        eventDayViewItemBuilder: (context, index, event) {
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
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'event-only-settings',
        onPressed: () => showSettingsSheet(
          context: context,
          title: 'Event Day View Settings',
          buildOptions: (setSheetState) => [
            SegmentSetting<TimeColumnPosition>(
              label: 'Time Column Position',
              value: timeColumnPosition.value,
              options: TimeColumnPosition.values,
              labels: const ['Left', 'Right', 'None'],
              onChanged: (v) => setSheetState(() => timeColumnPosition.value = v),
            ),
            SwitchSetting(
              label: 'Show Hourly',
              value: showHourly.value,
              onChanged: (v) => setSheetState(() => showHourly.value = v),
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
