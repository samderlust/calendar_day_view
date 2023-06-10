import 'package:calendar_day_view/src/extentions/list_extentions.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';

class CategoryCalendarDayView<T extends Object> extends StatelessWidget {
  const CategoryCalendarDayView({
    Key? key,
    required this.categories,
    required this.events,
    required this.startOfDay,
    this.endOfDay,
    required this.timeGap,
    this.heightPerMin = 1.0,
    this.evenRowColor,
    this.oddRowColor,
    this.verticalDivider,
    this.horizontalDivider,
    this.timeTextStyle,
    required this.eventBuilder,
    this.onTileTap,
  }) : super(key: key);
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> events;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay? endOfDay;

  /// time gap/duration of a row.
  final int timeGap;

  /// height in pixel per minute
  final double heightPerMin;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final VerticalDivider? verticalDivider;
  final Divider? horizontalDivider;
  final TextStyle? timeTextStyle;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final CategoryDayViewTileTap? onTileTap;

  @override
  Widget build(BuildContext context) {
    final timeList = getTimeList(
      startOfDay: startOfDay,
      endOfDay: endOfDay,
      timeGap: timeGap,
    );

    final rowHeight = heightPerMin * timeGap;
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final rowLength = constraints.maxWidth - 50;
          final tileWidth = rowLength / categories.length;
          return Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 50),
                  verticalDivider ?? const VerticalDivider(width: 0),
                  ...categories
                      .map(
                        (e) => [
                          SizedBox(
                            width: tileWidth,
                            height: 40,
                            child: Center(
                                child: Text(
                              e.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ),
                          const VerticalDivider(
                            width: 0,
                            color: Colors.red,
                          ),
                        ],
                      )
                      .expand((e) => e)
                      .toList()
                ],
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: timeList.length,
                separatorBuilder: (context, index) =>
                    horizontalDivider ?? const Divider(height: 0),
                itemBuilder: (context, index) {
                  final time = timeList.elementAt(index);
                  final rowEvents = events.where(
                    (event) => event.isInThisGap(time, timeGap),
                  );
                  return Container(
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? evenRowColor : oddRowColor,
                    ),
                    height: rowHeight,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Center(
                            child: Text(
                              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}",
                              style: timeTextStyle,
                            ),
                          ),
                        ),
                        verticalDivider ?? const VerticalDivider(width: 0),
                        ...categories
                            .map((category) => [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: onTileTap == null
                                        ? null
                                        : () => onTileTap!(category, time),
                                    child: SizedBox(
                                      width: tileWidth,
                                      height: rowHeight,
                                      child: eventBuilder(
                                          BoxConstraints(
                                            maxHeight: rowHeight,
                                            maxWidth: tileWidth,
                                          ),
                                          category,
                                          rowEvents.firstWhereOrNull((e) =>
                                              e.categoryId == category.id)),
                                    ),
                                  ),
                                  verticalDivider ??
                                      const VerticalDivider(width: 0),
                                ])
                            .expand((element) => element)
                            .toList()
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

List<TimeOfDay> getTimeList({
  required TimeOfDay startOfDay,
  TimeOfDay? endOfDay,
  required int timeGap,
}) {
  final timeEnd = endOfDay ?? const TimeOfDay(hour: 23, minute: 0);

  final timeCount = ((timeEnd.hour - startOfDay.hour) * 60) ~/ timeGap;
  DateTime first = DateTime.parse(
      "2012-02-27T${startOfDay.hour.toString().padLeft(2, '0')}:00");
  List<TimeOfDay> list = [];
  for (var i = 1; i <= timeCount; i++) {
    list.add(TimeOfDay.fromDateTime(first));
    first = first.add(Duration(minutes: timeGap));
  }
  return list;
}
