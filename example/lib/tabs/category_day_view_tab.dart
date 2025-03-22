import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../main.dart';

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

    return Container(
      padding: const EdgeInsets.only(
          // top: 100,
          // left: 50,
          // right: 50,
          // bottom: 50,
          ),
      child: Category2DDayView(
        config: CategoryDavViewConfig(
          currentDate: DateTime.now(),
          time12: true,
          allowHorizontalScroll: true,
          columnsPerPage: 2,
          endOfDay: const TimeOfDay(hour: 23, minute: 59),
        ),
        categories: categories,
        events: events,
        eventBuilder: (constraints, category, _, event) => GestureDetector(
          onTap: () => print(event),
          child: Container(
            constraints: constraints,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              border: Border.all(color: colorScheme.tertiary, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                event.value.toString(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
    );

    return CalendarDayView.category(
      config: CategoryDavViewConfig(
        time12: true,
        allowHorizontalScroll: true,
        columnsPerPage: 2,
        currentDate: DateTime.now(),
        timeGap: 60,
        heightPerMin: 1,
        evenRowColor: Colors.white,
        oddRowColor: Colors.grey[200],
        headerDecoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(.5),
        ),
        timeLabelBuilder: (context, time) => Text(
          timeFormat.format(time),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        logo: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(child: Text("C")),
        ),
      ),
      categories: categories,
      events: events,
      onTileTap: (category, time) {
        debugPrint(category.toString());
        debugPrint(time.toString());
      },
      controlBarBuilder: (goToPreviousTab, goToNextTab) => Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        height: 80,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filledTonal(
              onPressed: goToPreviousTab,
              icon: const Icon(
                Icons.arrow_left,
                size: 30,
              ),
            ),
            Text(
              DateTime.now().toString().split(":").first,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            IconButton.filledTonal(
              onPressed: goToNextTab,
              icon: const Icon(
                Icons.arrow_right,
                size: 30,
              ),
            ),
          ],
        ),
      ),
      eventBuilder: (constraints, category, _, event) => GestureDetector(
        onTap: () => print(event),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          constraints: constraints,
          width: constraints.maxWidth - 6,
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            border: Border.all(color: colorScheme.tertiary, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              event.value,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSecondaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
