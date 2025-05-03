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
    final colorScheme = Theme.of(context).colorScheme;

    final controller = useMemoized(() => CategoryDayViewController(), []);

    return Column(
      children: [
        Expanded(
          child: CategoryDayView2(
            controller: controller,
            events: events,
            config: CategoryDavViewConfig(
              currentDate: DateTime.now(),
              time12: true,
              columnsPerPage: 2,
              allowHorizontalScroll: true,
            ),
            categories: categories,
            onTileTap: (category, time) {
              debugPrint(category.toString());
              debugPrint(time.toString());
            },
            eventBuilder: (constraints, category, _, event) => GestureDetector(
              onTap: () => print(event),
              child: Container(
                constraints: constraints,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(color: colorScheme.secondaryContainer),
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
