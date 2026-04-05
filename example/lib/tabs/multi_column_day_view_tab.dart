import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';
import '../widgets/settings_sheet.dart';

/// Strategies for laying out overlapping events.
enum OverlapMode { defaultGreedy, stack, halfWidth }

String _overlapLabel(OverlapMode m) => switch (m) {
      OverlapMode.defaultGreedy => 'Default',
      OverlapMode.stack => 'Stack',
      OverlapMode.halfWidth => '½ Width',
    };

/// Custom strategy: put every event in column 0 with totalColumns 1.
/// Overlapping events visually stack on top of each other.
List<ColumnEvent<String>> _stackStrategy(
  List<DayEvent<String>> events, {
  DateTime? startOfDay,
  DateTime? endOfDay,
}) {
  final filtered = (startOfDay != null && endOfDay != null)
      ? events.where((e) => !e.start.isBefore(startOfDay) && !e.start.isAfter(endOfDay))
      : events;
  return [
    for (final e in filtered) ColumnEvent(event: e, column: 0, totalColumns: 1),
  ];
}

/// Custom strategy: force every event to half width (totalColumns: 2),
/// alternating between columns 0 and 1.
List<ColumnEvent<String>> _halfWidthStrategy(
  List<DayEvent<String>> events, {
  DateTime? startOfDay,
  DateTime? endOfDay,
}) {
  final sorted = [...events]..sort((a, b) => a.start.compareTo(b.start));
  final filtered = (startOfDay != null && endOfDay != null)
      ? sorted.where((e) => !e.start.isBefore(startOfDay) && !e.start.isAfter(endOfDay)).toList()
      : sorted;
  return [
    for (var i = 0; i < filtered.length; i++) ColumnEvent(event: filtered[i], column: i % 2, totalColumns: 2),
  ];
}

class MultiColumnDayViewTab extends HookWidget {
  const MultiColumnDayViewTab({
    super.key,
    required this.events,
  });

  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final heightPerMin = useState<double>(2);
    final cropBottomEvents = useState<bool>(false);
    final showCurrentTimeLine = useState<bool>(true);
    final scrollToCurrentTime = useState<bool>(true);
    final time12 = useState<bool>(true);
    final timeColumnPosition = useState<TimeColumnPosition>(TimeColumnPosition.left);
    final overlapMode = useState<OverlapMode>(OverlapMode.defaultGreedy);

    final colorScheme = Theme.of(context).colorScheme;

    final colors = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];

    final strategy = switch (overlapMode.value) {
      OverlapMode.defaultGreedy => null,
      OverlapMode.stack => _stackStrategy,
      OverlapMode.halfWidth => _halfWidthStrategy,
    };

    return Scaffold(
      body: CalendarDayView.multiColumn<String>(
        config: MultiColumnDayViewConfig<String>(
          currentDate: DateTime.now(),
          timeGap: timeGap.value,
          heightPerMin: heightPerMin.value,
          startOfDay: const TimeOfDay(hour: 4, minute: 0),
          endOfDay: const TimeOfDay(hour: 20, minute: 0),
          showCurrentTimeLine: showCurrentTimeLine.value,
          cropBottomEvents: cropBottomEvents.value,
          scrollToCurrentTime: scrollToCurrentTime.value,
          time12: time12.value,
          overlapStrategy: strategy,
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
        onTimeTap: (time) {
          debugPrint('onTimeTap: $time');
        },
        itemBuilder: (context, constraints, event, columnIndex, totalColumns) {
          return Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: colors[columnIndex % colors.length],
              border: Border.all(color: colorScheme.outline, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Text(
              event.value,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(fontSize: 12, color: colorScheme.onSecondaryContainer),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'multi-column-settings',
        onPressed: () => showSettingsSheet(
          context: context,
          title: 'Multi Column Day View Settings',
          buildOptions: (setSheetState) => [
            SegmentSetting<OverlapMode>(
              label: 'Overlap Strategy',
              value: overlapMode.value,
              options: OverlapMode.values,
              labels: OverlapMode.values.map(_overlapLabel).toList(),
              onChanged: (v) => setSheetState(() => overlapMode.value = v),
            ),
            SegmentSetting<int>(
              label: 'Time Gap',
              value: timeGap.value,
              options: const [15, 30, 60],
              labels: const ['15m', '30m', '60m'],
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
