import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CategoryDayViewTab extends StatelessWidget {
  const CategoryDayViewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryCalendarDayView(
      categories: [
        EventCategory(id: "1", name: "court 1"),
        EventCategory(id: "2", name: "court 2"),
        EventCategory(id: "3", name: "court 3"),
        EventCategory(id: "4", name: "court 4"),
      ],
      events: [],
      startOfDay: TimeOfDay(hour: 7, minute: 00),
      endOfDay: TimeOfDay(hour: 17, minute: 00),
      timeGap: 60,
      evenRowColor: Colors.white,
      oddRowColor: Colors.grey,
    );
  }
}
