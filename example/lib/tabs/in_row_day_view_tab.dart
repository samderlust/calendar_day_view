import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';
import '../widgets/settings_sheet.dart';

class InRowDayViewTab extends HookWidget {
  const InRowDayViewTab({super.key, required this.events});
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final heightPerMin = useState<double>(1);
    final withEventOnly = useState<bool>(false);
    final showCurrentTimeLine = useState<bool>(true);
    final scrollToCurrentTime = useState<bool>(false);
    final time12 = useState<bool>(false);
    final timeColumnPosition = useState<TimeColumnPosition>(TimeColumnPosition.left);

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CalendarDayView.inRow<String>(
        config: InRowDayViewConfig(
          heightPerMin: heightPerMin.value,
          showCurrentTimeLine: showCurrentTimeLine.value,
          scrollToCurrentTime: scrollToCurrentTime.value,
          timeGap: timeGap.value,
          showWithEventOnly: withEventOnly.value,
          time12: time12.value,
          currentDate: DateTime.now(),
          startOfDay: const TimeOfDay(hour: 3, minute: 00),
          endOfDay: const TimeOfDay(hour: 22, minute: 00),
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
        events: UnmodifiableListView(events),
        itemBuilder: (context, constraints, itemIndex, event) => Flexible(
          child: SizedBox(
            height: constraints.maxHeight,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => debugPrint(event.value),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: constraints.maxHeight,
                        decoration: BoxDecoration(
                          color: itemIndex % 2 == 0 ? colorScheme.tertiaryContainer : colorScheme.secondaryContainer,
                          border: Border.all(color: colorScheme.tertiary, width: 2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Center(
                          child: Text(
                            event.value,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onSecondaryContainer,
                              fontSize: constraints.maxWidth < 100 ? 10 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 2, thickness: 2, color: Colors.black)
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'in-row-settings',
        onPressed: () => showSettingsSheet(
          context: context,
          title: 'In Row Day View Settings',
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
            SegmentSetting<TimeColumnPosition>(
              label: 'Time Column Position',
              value: timeColumnPosition.value,
              options: TimeColumnPosition.values,
              labels: const ['Left', 'Right', 'None'],
              onChanged: (v) => setSheetState(() => timeColumnPosition.value = v),
            ),
            SwitchSetting(
              label: 'Row with Event Only',
              value: withEventOnly.value,
              onChanged: (v) => setSheetState(() => withEventOnly.value = v),
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
