import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final now = DateTime.now();

class OverflowDayViewTab extends HookWidget {
  const OverflowDayViewTab({
    Key? key,
    required this.events,
    this.onTimeTap,
  }) : super(key: key);
  final List<DayEvent<String>> events;
  final Function(DateTime)? onTimeTap;
  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: OverFlowCalendarDayView(
            onTimeTap: onTimeTap ?? print,
            events: UnmodifiableListView(events),
            dividerColor: Colors.black,
            currentDate: DateTime.now(),
            timeGap: timeGap.value,
            heightPerMin: .4,
            renderRowAsListView: true,
            showCurrentTimeLine: true,
            showMoreOnRowButton: true,
            overflowItemBuilder: (context, constraints, itemIndex, event) {
              return HookBuilder(builder: (context) {
                return GestureDetector(
                  key: ValueKey(event.hashCode),
                  onTap: () {
                    print(event.value);
                    print(event.start);
                    print(event.end);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    key: ValueKey(event.hashCode),
                    width: constraints.minWidth < 100
                        ? 100
                        :
                        // -3 for the margin
                        constraints.minWidth - 3,
                    height: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: itemIndex % 2 == 0
                          ? colorScheme.primary
                          : colorScheme.secondary,
                    ),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        event.value,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
        Row(
          children: [
            const Text('TimeGap:'),
            Radio<int>(
              value: 15,
              groupValue: timeGap.value,
              onChanged: (v) => timeGap.value = v!,
            ),
            const Text('15m'),
            Radio<int>(
              value: 20,
              groupValue: timeGap.value,
              onChanged: (v) => timeGap.value = v!,
            ),
            const Text('20m'),
            Radio<int>(
              value: 30,
              groupValue: timeGap.value,
              onChanged: (v) => timeGap.value = v!,
            ),
            const Text('30m'),
            Radio<int>(
              value: 60,
              groupValue: timeGap.value,
              onChanged: (v) => timeGap.value = v!,
            ),
            const Text('60m'),
          ],
        ),
      ],
    );
  }
}
