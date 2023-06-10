import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InRowDayViewTab extends HookWidget {
  const InRowDayViewTab({Key? key, required this.events}) : super(key: key);
  final List<DayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    final timeGap = useState<int>(60);
    final withEventOnly = useState<bool>(false);
    return Column(
      children: [
        Expanded(
          child: InRowCalendarDayView<String>(
            events: events,
            heightPerMin: 1,
            showCurrentTimeLine: true,
            dividerColor: Colors.black,
            timeGap: timeGap.value,
            showWithEventOnly: withEventOnly.value,
            startOfDay: const TimeOfDay(hour: 00, minute: 0),
            endOfDay: const TimeOfDay(hour: 22, minute: 0),
            itemBuilder: (context, constraints, event) => Flexible(
              child: HookBuilder(builder: (context) {
                final randomColor = useMemoized(() => getRandomColor());
                return GestureDetector(
                  onTap: () => print(event.value),
                  child: Container(
                    height: constraints.maxHeight,
                    color: randomColor,
                    child: Center(
                      child: Text(
                        event.value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: constraints.maxWidth < 100 ? 10 : 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
