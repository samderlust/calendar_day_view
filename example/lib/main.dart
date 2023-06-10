import 'dart:math';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:english_words/english_words.dart';
import 'package:example/tabs/category_day_view_tab.dart';
import 'package:example/tabs/event_day_view_tab.dart';
import 'package:example/tabs/in_row_day_view_tab.dart';
import 'package:example/tabs/overflow_day_view_tab.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

final rd = Random();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const CalendarDayViewExample(),
    );
  }
}

class CalendarDayViewExample extends HookWidget {
  const CalendarDayViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final dayEvents = useState<List<DayEvent<String>>>(fakeEvents());

    final categories = useState([
      EventCategory(id: "1", name: "cate 1"),
      EventCategory(id: "2", name: "cate 2"),
      EventCategory(id: "3", name: "cate 3"),
      EventCategory(id: "4", name: "cate 4"),
    ]);
    final categoryEvents = useState<List<CategorizedDayEvent<String>>>(
        genEvents(categories.value.length));

    void addCategory() {
      categories.value = [
        ...categories.value,
        EventCategory(
            id: "${categories.value.length + 1}",
            name: "cate ${categories.value.length + 1}"),
      ];
      categoryEvents.value = genEvents(categories.value.length);
    }

    final bodyItems = [
      OverflowDayViewTab(
        events: dayEvents.value
            .map(
              (e) => e.copyWith(
                end: TimeOfDay(
                  hour: e.start.hour + 1,
                  minute: e.start.minute + 30 + rd.nextInt(30),
                ),
              ),
            )
            .toList(),
      ),
      CategoryDayViewTab(
        events: categoryEvents.value,
        categories: categories.value,
      ),
      InRowDayViewTab(
        events: dayEvents.value,
      ),
      EventDayViewTab(events: dayEvents.value),
    ];

    final currentIndex = useState<int>(0);

    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedFontSize: 14,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.blue,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Overflow"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_view_day), label: "Category"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "In Row"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Events"),
            ],
            onTap: (value) => currentIndex.value = value,
            currentIndex: currentIndex.value,
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverAppBar.large(
                floating: true,
                pinned: true,
                title: Text(
                  getTitle(currentIndex.value),
                  style: const TextStyle(color: Colors.white),
                ),
                actions: [
                  if (currentIndex.value != 1)
                    TextButton.icon(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () => dayEvents.value = fakeEvents(),
                      icon: Icon(Icons.refresh),
                      label: Text("events"),
                    ),
                  if (currentIndex.value == 1) ...[
                    TextButton.icon(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () => categoryEvents.value =
                          genEvents(categories.value.length),
                      icon: Icon(Icons.refresh),
                      label: Text("events"),
                    ),
                    const SizedBox(width: 20),
                    TextButton.icon(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: addCategory,
                      icon: Icon(Icons.add),
                      label: Text("category"),
                    ),
                  ],
                ],
              ),
            ],
            body: bodyItems[currentIndex.value],
          ),
        ),
      ),
    );
  }
}

String getTitle(int index) {
  switch (index) {
    case 0:
      return "Overflow Day View";
    case 1:
      return "Category Day View";
    case 2:
      return "In Row Day View";
    case 3:
      return "Events Day View";

    default:
      return "Calendar Day View";
  }
}

List<DayEvent<String>> fakeEvents() => faker.randomGenerator.amount(
    (i) => DayEvent(
          value: faker.animal.name(),
          start: TimeOfDay(
              hour: faker.randomGenerator.integer(17, min: 7), minute: 0),
        ),
    30,
    min: 10);

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
