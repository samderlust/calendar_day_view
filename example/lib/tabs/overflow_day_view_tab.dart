import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class OverflowDayViewTab extends HookWidget {
  const OverflowDayViewTab({
    Key? key,
    required this.events,
  }) : super(key: key);
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    return Column(
      children: [
        Expanded(
          child: OverFlowCalendarDayView(
            events: events,
            dividerColor: Colors.black,
            startOfDay: const TimeOfDay(hour: 00, minute: 0),
            endOfDay: const TimeOfDay(hour: 23, minute: 0),
            timeGap: timeGap.value,
            renderRowAsListView: true,
            showCurrentTimeLine: true,
            showMoreOnRowButton: true,
            overflowItemBuilder: (context, constraints, event) {
              return Container(
                margin: const EdgeInsets.only(right: 3),
                key: ValueKey(event.hashCode),
                width: constraints.minWidth < 100
                    ? 100
                    :
                    // -3 for the margin
                    constraints.minWidth - 3,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(
                    event.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
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
