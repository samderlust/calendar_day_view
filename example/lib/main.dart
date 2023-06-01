import 'dart:math';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:english_words/english_words.dart';
import 'package:example/tabs/event_day_view_tab.dart';
import 'package:example/tabs/in_row_day_view_tab.dart';
import 'package:example/tabs/overflow_day_view_tab.dart';
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
    final bodyItems = [
      OverflowDayViewTab(
        events: fakeEvents
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
      InRowDayViewTab(
        events: fakeEvents,
      ),
      EventDayViewTab(events: fakeEvents),
    ];

    final currentIndex = useState<int>(0);
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Theme.of(context).backgroundColor,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Overflow"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "In Row"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Events"),
            ],
            onTap: (value) => currentIndex.value = value,
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
              SliverAppBar.large(
                floating: true,
                pinned: true,
                title: Text(
                  getTitle(currentIndex.value),
                  style: TextStyle(color: Colors.white),
                ),
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
      return "In Row Day View";
    case 2:
      return "Events Day View";

    default:
      return "Calendar Day View";
  }
}

final now = DateTime.now();
final List<DayEvent<String>> fakeEvents = [
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour + 3)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour + 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 2)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 3)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 15)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 15)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 30)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
  DayEvent(
    start: TimeOfDay.fromDateTime(
        DateTime(now.year, now.month, now.day, now.hour - 4, now.minute - 30)),
    value: nouns.elementAt(rd.nextInt(2000)),
  ),
];
