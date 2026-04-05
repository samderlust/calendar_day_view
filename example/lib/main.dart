import 'dart:math';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:example/tabs/category_overflow_day_view_tab.dart';
import 'package:example/tabs/event_day_view_tab.dart';
import 'package:example/tabs/in_row_day_view_tab.dart';
import 'package:example/tabs/multi_column_day_view_tab.dart';
import 'package:example/tabs/overflow_day_view_tab.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'tabs/category_day_view_tab.dart';

final timeFormat = DateFormat('HH:mm');
final timeFormat12 = DateFormat('h:mm a');

String formatTime(DateTime t, {required bool use12}) => (use12 ? timeFormat12 : timeFormat).format(t);

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
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
      home: const CalendarDayViewExample(),
    );
  }
}

class CalendarDayViewExample extends HookWidget {
  const CalendarDayViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    final dayEvents = useState<List<DayEvent<String>>>(fakeEvents()
        .map(
          (e) => e.copyWith(
            end: e.start.add(Duration(minutes: faker.randomGenerator.element([20, 30, 90, 60]))),
          ),
        )
        .toList());

    final categories = useState([
      EventCategory(id: "1", name: "cate 1"),
      EventCategory(id: "2", name: "cate 2"),
      EventCategory(id: "3", name: "cate 3"),
      EventCategory(id: "4", name: "cate 4"),
    ]);
    final categoryEvents = useState<List<CategorizedDayEvent<String>>>(genEvents(categories.value.length));

    void addCategory() {
      categories.value = [
        ...categories.value,
        EventCategory(id: "${categories.value.length + 1}", name: "cate ${categories.value.length + 1}"),
      ];
      categoryEvents.value = genEvents(categories.value.length);
    }

    final bodyItems = [
      OverflowDayViewTab(
        events: dayEvents.value,
        onAddEvent: (event) {
          dayEvents.value = [...dayEvents.value, event];
        },
      ),
      CategoryOverflowDayViewTab(
        events: categoryEvents.value,
        categories: categories.value,
        addEventOnClick: (cate, time) {
          categoryEvents.value = [...categoryEvents.value, CategorizedDayEvent(categoryId: cate.id, value: faker.conference.name(), start: time)];
        },
      ),
      CategoryDayViewTab(
        events: categoryEvents.value,
        categories: categories.value,
        addEventOnClick: (cate, time) {
          categoryEvents.value = [...categoryEvents.value, CategorizedDayEvent(categoryId: cate.id, value: faker.conference.name(), start: time)];
        },
      ),
      InRowDayViewTab(
        events: dayEvents.value,
      ),
      EventDayViewTab(events: dayEvents.value),
      MultiColumnDayViewTab(events: dayEvents.value),
    ];

    final currentIndex = useState<int>(0);

    final isCategoryTab = currentIndex.value == 1 || currentIndex.value == 2;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex.value,
          onDestinationSelected: (v) => currentIndex.value = v,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Overflow'),
            NavigationDestination(icon: Icon(Icons.calendar_view_day), label: 'Cat. Overflow'),
            NavigationDestination(icon: Icon(Icons.calendar_view_day), label: 'Category'),
            NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'In Row'),
            NavigationDestination(icon: Icon(Icons.calendar_view_month), label: 'Events'),
            NavigationDestination(icon: Icon(Icons.view_column), label: 'Multi Col'),
          ],
        ),
        appBar: AppBar(
          title: Text(
            '${getTitle(currentIndex.value)} — ${isCategoryTab ? categoryEvents.value.length : dayEvents.value.length} events',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'Refresh events',
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (isCategoryTab) {
                  categoryEvents.value = genEvents(categories.value.length);
                } else {
                  dayEvents.value = fakeEvents();
                }
              },
            ),
            if (isCategoryTab)
              IconButton(
                tooltip: 'Add category',
                icon: const Icon(Icons.add),
                onPressed: addCategory,
              ),
          ],
        ),
        body: IndexedStack(
          index: currentIndex.value,
          children: bodyItems,
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
      return "Category Overflow Day View";
    case 2:
      return "Category Day View";
    case 3:
      return "In Row Day View";
    case 4:
      return "Events Day View";
    case 5:
      return "Multi Column Day View";

    default:
      return "Calendar Day View";
  }
}

List<DayEvent<String>> fakeEvents() => faker.randomGenerator.amount((i) {
      final start = DateTime.now().copyWith(
        hour: faker.randomGenerator.integer(19, min: 5),
        minute: faker.randomGenerator.element([0, 10, 20, 40]),
        second: 0,
      );
      return DayEvent(
        value: faker.conference.name(),
        start: start,
        end: start.add(
          Duration(minutes: faker.randomGenerator.element([20, 30, 90, 60])),
        ),
      );
    }, 30, min: 10);

List<CategorizedDayEvent<String>> genEvents(int categoryLength) => faker.randomGenerator.amount(
      (i) {
        final hour = faker.randomGenerator.integer(17, min: 7);
        final start = DateTime.now().copyWith(
          hour: hour,
          minute: faker.randomGenerator.element([0, 15, 20]),
          second: 0,
        );
        return CategorizedDayEvent(
            categoryId: faker.randomGenerator.integer(categoryLength + 1, min: 1).toString(),
            value: faker.conference.name(),
            start: start,
            end: start.add(
              Duration(minutes: faker.randomGenerator.element([90, 60])),
            )
            // end: DateTime.now().copyWith(
            //   hour: faker.randomGenerator.integer(2, min: 1) + hour,
            //   minute: faker.randomGenerator.element([0, 30]),
            //   second: 0,
            // ),
            );
      },
      categoryLength * 5,
      min: 10,
    );
