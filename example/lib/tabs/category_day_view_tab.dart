import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:calendar_day_view/calendar_day_view.dart';

class CategoryDayViewTab extends HookWidget {
  const CategoryDayViewTab({
    super.key,
    required this.categories,
    required this.events,
  });
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<String>> events;

  @override
  Widget build(BuildContext context) {
    // final categories = useState([
    //   EventCategory(id: "1", name: "court 1"),
    //   EventCategory(id: "2", name: "court 2"),
    //   EventCategory(id: "3", name: "court 3"),
    //   EventCategory(id: "4", name: "court 4"),
    // ]);

    // final events = useState<List<CategorizedDayEvent<String>>>(
    //     genEvents(categories.length));

    // void addCategory() {
    //   categories = [
    //     ...categories,
    //     EventCategory(
    //         id: "${categories.length + 1}",
    //         name: "court ${categories.length + 1}"),
    //   ];
    //   events = genEvents(categories.value.length);
    // }

    return Column(
      children: [
        // const SizedBox(height: 10),
        // Row(
        //   children: [
        //     const SizedBox(width: 20),
        //     ElevatedButton(
        //       onPressed: () =>
        //           events = genEvents(categories.length),
        //       child: const Text("Re-generate EVents"),
        //     ),
        //     const SizedBox(width: 20),
        //     ElevatedButton(
        //       onPressed: addCategory,
        //       child: const Text("Add Category"),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 10),
        Expanded(
          child: CategoryCalendarDayView(
            categories: categories,
            events: events,
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
                  color: Theme.of(context).colorScheme.primary,
                  border: Border.all(width: .5, color: Colors.black26),
                ),
                child: Center(
                  child: Text(
                    event.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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

List<CategorizedDayEvent<String>> genEvents(int categoryLength) =>
    faker.randomGenerator.amount(
      (i) {
        final hour = faker.randomGenerator.integer(17, min: 7);
        return CategorizedDayEvent(
          categoryId: faker.randomGenerator
              .integer(categoryLength + 1, min: 1)
              .toString(),
          value: faker.animal.name(),
          start: TimeOfDay(
            hour: hour,
            minute: faker.randomGenerator.element([0]),
          ),
          end: TimeOfDay(
            hour: faker.randomGenerator.integer(2, min: 1) + hour,
            minute: faker.randomGenerator.element([0, 30]),
          ),
        );
      },
      categoryLength * 5,
      min: 10,
    );
