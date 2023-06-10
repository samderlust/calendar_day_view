import 'package:calendar_day_view/calendar_day_view.dart';
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
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => events.value = genEvents(),
          child: const Text("Re-generate EVents"),
        ),
        const SizedBox(height: 10),
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
            startOfDay: const TimeOfDay(hour: 7, minute: 00),
            endOfDay: const TimeOfDay(hour: 17, minute: 00),
            timeGap: 60,
            heightPerMin: 1,
            evenRowColor: Colors.white,
            oddRowColor: Colors.grey,
            headerDecoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(.5),
            ),
            eventBuilder: (constraints, category, event) => GestureDetector(
              onTap: () => print(event),
              child: Container(
                constraints: constraints,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(width: .5, color: Colors.black26),
                ),
                child: Center(
                  child: Text(
                    event.value,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

List<CategorizedDayEvent<String>> genEvents() => faker.randomGenerator.amount(
      (i) {
        final hour = faker.randomGenerator.integer(17, min: 7);
        return CategorizedDayEvent(
          categoryId: faker.randomGenerator.integer(4, min: 1).toString(),
          value: faker.animal.name(),
          start: TimeOfDay(
            hour: hour,
            minute: faker.randomGenerator.element([0, 30]),
          ),
          end: TimeOfDay(
            hour: faker.randomGenerator.integer(2, min: 1) + hour,
            minute: faker.randomGenerator.element([0, 30]),
          ),
        );
      },
      20,
      min: 5,
    );
