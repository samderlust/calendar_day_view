import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';

class MultiColumnDayViewTab extends HookWidget {
  const MultiColumnDayViewTab({
    super.key,
    required this.events,
  });

  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final cropBottomEvents = useState<bool>(false);
    final colorScheme = Theme.of(context).colorScheme;

    final colors = [
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];

    return Column(
      children: [
        Expanded(
          child: CalendarDayView.multiColumn(
            config: MultiColumnDayViewConfig(
              currentDate: DateTime.now(),
              timeGap: timeGap.value,
              heightPerMin: 2,
              startOfDay: const TimeOfDay(hour: 4, minute: 0),
              endOfDay: const TimeOfDay(hour: 20, minute: 0),
              showCurrentTimeLine: true,
              cropBottomEvents: cropBottomEvents.value,
              scrollToCurrentTime: true,
              dividerColor: Colors.black,
              time12: true,
              timeLabelBuilder: (context, time) => Text(
                timeFormat.format(time),
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSecondaryContainer,
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
