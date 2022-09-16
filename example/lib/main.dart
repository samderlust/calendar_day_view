import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:example/tabs/event_day_view_tab.dart';
import 'package:example/tabs/in_row_day_view_tab.dart';
import 'package:example/tabs/overflow_day_view_tab.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalendarDayViewExample(),
    );
  }
}

class CalendarDayViewExample extends StatelessWidget {
  const CalendarDayViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Calendar Day Views'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'In Row'),
                Tab(text: 'Event Only'),
                Tab(text: 'Overflow'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TabBarView(
              children: [
                InRowDayViewTab(
                  events: fakeEvents,
                ),
                EventDayViewTab(events: fakeEvents),
                OverflowDayViewTab(
                  events: fakeEvents
                      .map(
                        (e) => e.copyWith(
                            end: TimeOfDay(hour: e.start.hour + 2, minute: 0)),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final now = DateTime.now();
final List<DayEvent<String>> fakeEvents = [
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour + 3)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour + 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 2)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 15)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 15)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 30)),
    value: UniqueKey().toString(),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 30)),
    value: UniqueKey().toString(),
  ),
];
