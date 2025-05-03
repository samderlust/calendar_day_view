import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CategoryOverflowDayViewTab extends HookWidget {
  const CategoryOverflowDayViewTab({
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
    final colorScheme = Theme.of(context).colorScheme;
    final controller = useMemoized(() => CategoryDayViewController(), []);

    return Column(
      children: [
        Expanded(
          child: CalendarDayViewFactory.categoryOverflow(
            config: CategoryDavViewConfig(
              currentDate: DateTime.now(),
              time12: true,
              // allowHorizontalScroll: true,
              // columnsPerPage: 2,
              endOfDay: const TimeOfDay(hour: 23, minute: 59),
            ),
            categories: categories,
            events: events,
            eventBuilder: (constraints, category, time, event) => GestureDetector(
              onTap: () {
                print("constraints:: $constraints");
                print("time:: $time");
                print("category:: $category");
                print("event:: $event");
              },
              child: Container(
                constraints: constraints,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  border: Border.all(color: colorScheme.tertiary, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                  child: Text(event.value.toString(), textAlign: TextAlign.center, overflow: TextOverflow.fade),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                controller.goToPreviousTab();
              },
              label: const Text("Previous Tab"),
              icon: const Icon(Icons.arrow_left),
            ),
            TextButton.icon(
              onPressed: () {
                controller.goToNextTab();
              },
              label: const Text("Next Tab"),
              icon: const Icon(Icons.arrow_right),
            ),
          ],
        ),
        Row(
          children: [
            for (var i = 0; i < categories.length; i++)
              OutlinedButton(
                onPressed: () {
                  controller.goToColumn(i);
                },
                child: Text(categories[i].name),
              ),
          ],
        )
      ],
    );
  }
}
