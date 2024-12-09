import 'dart:collection';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InRowDayViewTab extends HookWidget {
  const InRowDayViewTab({Key? key, required this.events}) : super(key: key);
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final withEventOnly = useState<bool>(false);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: CalendarDayView<String>.inRow(
            config: InRowDayViewConfig(
              heightPerMin: 1,
              showCurrentTimeLine: true,
              dividerColor: Colors.black,
              timeGap: timeGap.value,
              showWithEventOnly: withEventOnly.value,
              currentDate: DateTime.now(),
              startOfDay: TimeOfDay(hour: 3, minute: 00),
              endOfDay: TimeOfDay(hour: 22, minute: 00),
            ),
            events: UnmodifiableListView(events),
            itemBuilder: (context, constraints, itemIndex, event) => Flexible(
              child: HookBuilder(builder: (context) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => print(event.value),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              height: constraints.maxHeight,
                              decoration: BoxDecoration(
                                color: itemIndex % 2 == 0
                                    ? colorScheme.tertiaryContainer
                                    : colorScheme.secondaryContainer,
                                border: Border.all(
                                    color: colorScheme.tertiary, width: 2),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  event.value,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: colorScheme.onSecondaryContainer,
                                    fontSize:
                                        constraints.maxWidth < 100 ? 10 : 15,
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
                );
              }),
            ),
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
        Row(
          children: [
            const Text('Row with Event Only: '),
            Checkbox(
              value: withEventOnly.value,
              onChanged: (v) => withEventOnly.value = v!,
            ),
          ],
        )
      ],
    );
  }
}
