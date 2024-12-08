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
    final renderAsList = useState<bool>(true);

    final cropBottomEvents = useState<bool>(true);

    final size = MediaQuery.sizeOf(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: CalendarDayView.overflow(
            onTimeTap: onTimeTap ?? print,
            events: UnmodifiableListView(events),
            dividerColor: Colors.black,
            currentDate: DateTime.now(),
            timeGap: timeGap.value,
            heightPerMin: 2,
            endOfDay: TimeOfDay(hour: 18, minute: 0),
            startOfDay: const TimeOfDay(hour: 7, minute: 0),
            renderRowAsListView: renderAsList.value,
            showCurrentTimeLine: true,
            cropBottomEvents: cropBottomEvents.value,
            showMoreOnRowButton: true,
            time12: true,
            overflowItemBuilder: (context, constraints, itemIndex, event) {
              return HookBuilder(builder: (context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  key: ValueKey(event.hashCode),
                  onTap: () {
                    print(event.value);
                    print(event.start);
                    print(event.end);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 3, left: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    key: ValueKey(event.hashCode),
                    width: !renderAsList.value
                        ? (constraints.minWidth) - 6
                        : size.width / 4 - 6,
                    height: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: itemIndex % 2 == 0
                          ? colorScheme.tertiaryContainer
                          : colorScheme.secondaryContainer,
                      border: Border.all(color: colorScheme.tertiary, width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        event.value,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: colorScheme.onSecondaryContainer,
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
            Row(
              children: [
                const Text("Render List Row"),
                Radio(
                    groupValue: renderAsList.value,
                    value: true,
                    onChanged: (v) => renderAsList.value = v!)
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                const Text("Render Fix Row"),
                Radio(
                    groupValue: renderAsList.value,
                    value: false,
                    onChanged: (v) => renderAsList.value = v!)
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Text("Crop Bottom Events"),
            Checkbox(
                value: cropBottomEvents.value,
                onChanged: (v) => cropBottomEvents.value = v!)
          ],
        ),
        TimeGapSelection(
          timeGap: timeGap.value,
          onChanged: (p0) => timeGap.value = p0!,
        ),
      ],
    );
  }
}

class TimeGapSelection extends StatelessWidget {
  const TimeGapSelection({
    super.key,
    required this.timeGap,
    required this.onChanged,
  });

  final int timeGap;
  final void Function(int?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('TimeGap:'),
        Radio<int>(
          value: 15,
          groupValue: timeGap,
          onChanged: onChanged,
        ),
        const Text('15m'),
        Radio<int>(
          value: 20,
          groupValue: timeGap,
          onChanged: onChanged,
        ),
        const Text('20m'),
        Radio<int>(
          value: 30,
          groupValue: timeGap,
          onChanged: onChanged,
        ),
        const Text('30m'),
        Radio<int>(
          value: 60,
          groupValue: timeGap,
          onChanged: onChanged,
        ),
        const Text('60m'),
      ],
    );
  }
}
