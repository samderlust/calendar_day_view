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
            allowHorizontalScroll: true,
            categories: categories,
            columnsPerPage: 2,
            events: events,
            onTileTap: (category, time) {
              print(category);
              print(time);
            },
            currentDate: DateTime.now(),
            timeGap: 60,
            heightPerMin: 1,
            evenRowColor: Colors.white,
            oddRowColor: Colors.grey,
            headerDecoration: BoxDecoration(
              color: Colors.lightBlueAccent.withOpacity(.5),
            ),
            controlBarBuilder: (goToPreviousTab, goToNextTab) => Container(
              color: Colors.green,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filledTonal(
                    onPressed: goToPreviousTab,
                    icon: const Icon(Icons.arrow_left),
                  ),
                  Text(DateTime.now().toString().split(":").first),
                  IconButton.filledTonal(
                    onPressed: goToNextTab,
                    icon: const Icon(Icons.arrow_right),
                  ),
                ],
              ),
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
