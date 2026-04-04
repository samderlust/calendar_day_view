import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';

class InRowDayViewTab extends HookWidget {
  const InRowDayViewTab({super.key, required this.events});
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final withEventOnly = useState<bool>(false);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: CalendarDayView.inRow<String>(
            config: InRowDayViewConfig(
              heightPerMin: 1,
              showCurrentTimeLine: true,
              dividerColor: Colors.black,
              timeGap: timeGap.value,
              showWithEventOnly: withEventOnly.value,
              currentDate: DateTime.now(),
              startOfDay: const TimeOfDay(hour: 3, minute: 00),
              endOfDay: const TimeOfDay(hour: 22, minute: 00),
              timeLabelBuilder: (context, time) => Text(
                timeFormat.format(time),
                style: const TextStyle(fontWeight: FontWeight.bold),
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
                      const VerticalDivider(
                        width: 2,
                        thickness: 2,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ),
            ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              const Text('Row with Event Only: '),
              Switch(
                value: withEventOnly.value,
                onChanged: (v) => withEventOnly.value = v,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
