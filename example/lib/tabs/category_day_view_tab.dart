import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryDayViewTab extends HookWidget {
  const CategoryDayViewTab({
    super.key,
    required this.categories,
    required this.events,
    this.addEventOnClick,
  });
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<String>> events;

  final Function(EventCategory, DateTime)? addEventOnClick;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CategoryCalendarDayView(
            categories: categories,
            events: events,
            onTileTap: (category, time) {
              print(category);
              print(time);
            },
            startOfDay: DateTime.now().copyWith(hour: 7, minute: 00),
            endOfDay: DateTime.now().copyWith(hour: 17, minute: 00),
            timeGap: 60,
            heightPerMin: 1,
            evenRowColor: Colors.white,
            oddRowColor: Colors.grey,
            headerDecoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(.5),
            ),
            eventBuilder: (constraints, category, _, event) => event == null
                ? SizedBox.shrink()
                : GestureDetector(
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
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
