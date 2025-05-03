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

    return Category2DOverflowDayView(
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
          decoration: BoxDecoration(color: colorScheme.secondaryContainer),
          child: Center(
            child: Text(
              event.value.toString(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ),
    );
    return CalendarDayView.categoryOverflow(
      config: CategoryDavViewConfig(
        columnsPerPage: 2,
        endOfDay: const TimeOfDay(hour: 21, minute: 00),
        time12: true,
        allowHorizontalScroll: true,
        currentDate: DateTime.now(),
        timeGap: 60,
        heightPerMin: 3,
        evenRowColor: Colors.white,
        oddRowColor: Colors.grey[200],
        headerDecoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(.5),
        ),
        logo: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(child: Text("C")),
        ),
        timeColumnWidth: 70,
      ),
      categories: categories,
      events: events,
      onTileTap: (category, time) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text("This slot is available $time -- $category"),
          ),
        );
      },
      backgroundTimeTileBuilder: (context, constraints, rowTime, category, isOddRow) {
        return switch (rowTime) {
          var t when t.isBefore(DateTime.now()) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("This slot is Unavailable $rowTime -- $category"),
                ));
              },
              child: Container(
                constraints: constraints,
                color: categories.indexOf(category) % 2 == 0 ? Colors.black54 : Colors.black87,
              ),
            ),
          _ => const SizedBox.shrink(),
        };
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
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.teal,
            content: Text(event.toString()),
          ));
        },
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
