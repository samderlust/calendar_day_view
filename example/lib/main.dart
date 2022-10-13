import 'dart:math';

import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:english_words/english_words.dart';
import 'package:example/tabs/event_day_view_tab.dart';
import 'package:example/tabs/in_row_day_view_tab.dart';
import 'package:example/tabs/overflow_day_view_tab.dart';
import 'package:flutter/material.dart';

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

class CalendarDayViewExample extends StatelessWidget {
  const CalendarDayViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            title: const Text('Calendar Day Views'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Overflow'),
                Tab(text: 'In Row'),
                Tab(text: 'Event Only'),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
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
