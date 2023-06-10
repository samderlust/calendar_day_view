import 'dart:math';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:example/main.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryDayViewTab extends HookWidget {
  const CategoryDayViewTab({super.key});

  @override
  Widget build(BuildContext context) {
    final events = useState<List<CategorizedDayEvent<String>>>(genEvents());
    return Column(
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => events.value = genEvents(),
          child: Text("Re-generate EVents"),
        ),
        Expanded(
          child: CategoryCalendarDayView(
            categories: [
              EventCategory(id: "1", name: "court 1"),
              EventCategory(id: "2", name: "court 2"),
              EventCategory(id: "3", name: "court 3"),
              EventCategory(id: "4", name: "court 4"),
            ],
            events: events.value,
            onTileTap: (category, time) {
              print(category);
              print(time);
            },
            startOfDay: TimeOfDay(hour: 7, minute: 00),
            endOfDay: TimeOfDay(hour: 17, minute: 00),
            timeGap: 60,
            evenRowColor: Colors.white,
            oddRowColor: Colors.grey,
            eventBuilder: (constraints, category, event) =>
                Text(event?.value.toString() ?? ''),
          ),
        ),
      ],
    );
  }
}

List<CategorizedDayEvent<String>> genEvents() =>
    faker.randomGenerator.amount((i) {
      final hour = faker.randomGenerator.integer(17, min: 7);
      return CategorizedDayEvent(
        categoryId: faker.randomGenerator.integer(4, min: 1).toString(),
        value: faker.animal.name(),
        start: TimeOfDay(
          hour: hour,
          minute: 0,
        ),
        end: TimeOfDay(
          hour: faker.randomGenerator.integer(2, min: 1) + hour,
          minute: 0,
        ),
      );
    }, 20, min: 5);
