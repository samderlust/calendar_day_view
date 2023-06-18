import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';
import '../utils/date_time_utils.dart';

class CategoryCalendarDayView<T extends Object> extends StatelessWidget {
  const CategoryCalendarDayView({
    Key? key,
    required this.categories,
    required this.events,
    required this.startOfDay,
    required this.endOfDay,
    required this.timeGap,
    this.heightPerMin = 1.0,
    this.evenRowColor,
    this.oddRowColor,
    this.verticalDivider,
    this.horizontalDivider,
    this.timeTextStyle,
    required this.eventBuilder,
    this.onTileTap,
    this.headerTileBuilder,
    this.headerDecoration,
    this.logo,
    this.timeColumnWidth = 50,
  }) : super(key: key);
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> events;

  /// width of the first column where times are displayed
  final double timeColumnWidth;

  /// To set the start time of the day view
  final DateTime startOfDay;

  /// To set the end time of the day view
  final DateTime endOfDay;

  /// time gap/duration of a row.
  ///
  /// This will determine the minimum height of a row
  /// row height is calculated by `rowHeight = heightPerMin * timeGap`
  final int timeGap;

  /// height in pixel per minute
  final double heightPerMin;

  /// background color of the even-indexed row
  final Color? evenRowColor;

  /// background color of the odd-indexed row
  final Color? oddRowColor;

  /// dividers that run vertically in the day view
  final VerticalDivider? verticalDivider;

  /// dividers that run horizontally in the day view
  final Divider? horizontalDivider;

  /// time label text style
  final TextStyle? timeTextStyle;

  /// event builder
  final CategoryDayViewEventBuilder<T> eventBuilder;

  /// call when you tap on an empty tile
  ///
  /// provide [EventCategory] and [DateTime]  of that tile
  final CategoryDayViewTileTap? onTileTap;

  /// build category header
  final CategoryDayViewHeaderTileBuilder? headerTileBuilder;

  /// header row decoration
  final BoxDecoration? headerDecoration;

  /// The widget that will be place at top left corner tile of this day view
  final Widget? logo;

  @override
  Widget build(BuildContext context) {
    final timeList = getTimeList(
      startOfDay,
      endOfDay,
      timeGap,
    );

    final rowHeight = heightPerMin * timeGap;
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final rowLength = constraints.maxWidth - timeColumnWidth;
          final tileWidth = rowLength / categories.length;
          return SizedBox(
            width: constraints.maxWidth,
            child: Column(
              children: [
                horizontalDivider ?? const Divider(height: 0),
                DayViewHeader(
                  rowHeight: rowHeight,
                  verticalDivider: verticalDivider,
                  categories: categories,
                  headerTileBuilder: headerTileBuilder,
                  tileWidth: tileWidth,
                  headerDecoration: headerDecoration,
                  timeColumnWidth: timeColumnWidth,
                  logo: logo,
                ),
                horizontalDivider ?? const Divider(height: 0),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: timeList.length,
                  separatorBuilder: (context, index) =>
                      horizontalDivider ?? const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final time = timeList.elementAt(index);
                    final rowEvents = events
                        .where(
                          (event) => event.isInThisGap(time, timeGap),
                        )
                        .toList();
                    return Container(
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? evenRowColor : oddRowColor,
                      ),
                      constraints: BoxConstraints(
                        minHeight: rowHeight,
                      ),
                      child: DayViewRow<T>(
                        time: time,
                        timeTextStyle: timeTextStyle,
                        verticalDivider: verticalDivider,
                        categories: categories,
                        rowEvents: rowEvents,
                        onTileTap: onTileTap,
                        tileWidth: tileWidth,
                        rowHeight: rowHeight,
                        eventBuilder: eventBuilder,
                        timeColumnWidth: timeColumnWidth,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DayViewRow<T extends Object> extends StatelessWidget {
  const DayViewRow({
    super.key,
    required this.time,
    required this.timeTextStyle,
    required this.verticalDivider,
    required this.categories,
    required this.rowEvents,
    required this.onTileTap,
    required this.tileWidth,
    required this.rowHeight,
    required this.eventBuilder,
    required this.timeColumnWidth,
  });

  final DateTime time;
  final TextStyle? timeTextStyle;
  final VerticalDivider? verticalDivider;
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> rowEvents;
  final CategoryDayViewTileTap<T>? onTileTap;
  final double tileWidth;
  final double rowHeight;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final double timeColumnWidth;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: timeColumnWidth,
            child: Center(
              child: Text(
                "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}",
                style: timeTextStyle,
              ),
            ),
          ),
          verticalDivider ?? const VerticalDivider(width: 0),
          ...categories
              .map((category) {
                final event = rowEvents
                    .firstWhereOrNull((e) => e.categoryId == category.id);

                final constraints = BoxConstraints(
                  minHeight: rowHeight,
                  maxWidth: tileWidth,
                );
                return [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (onTileTap == null || event != null)
                        ? null
                        : () => onTileTap!(category, time),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: tileWidth,
                        minHeight: rowHeight,
                      ),
                      child: eventBuilder(
                        constraints,
                        category,
                        time,
                        event,
                      ),
                    ),
                  ),
                  verticalDivider ?? const VerticalDivider(width: 0),
                ];
              })
              .expand((element) => element)
              .toList()
        ],
      ),
    );
  }
}

class DayViewHeader extends StatelessWidget {
  const DayViewHeader({
    super.key,
    required this.rowHeight,
    required this.verticalDivider,
    required this.categories,
    required this.headerTileBuilder,
    required this.tileWidth,
    this.headerDecoration,
    required this.timeColumnWidth,
    this.logo,
  });

  final double rowHeight;
  final VerticalDivider? verticalDivider;
  final List<EventCategory> categories;
  final CategoryDayViewHeaderTileBuilder? headerTileBuilder;
  final double tileWidth;
  final BoxDecoration? headerDecoration;
  final Widget? logo;
  final double timeColumnWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: headerDecoration,
      constraints: BoxConstraints(minHeight: rowHeight),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: timeColumnWidth, minHeight: rowHeight),
              child: logo ?? SizedBox(width: timeColumnWidth),
            ),
            verticalDivider ?? const VerticalDivider(width: 0),
            ...categories
                .map(
                  (category) => [
                    headerTileBuilder != null
                        ? headerTileBuilder!(
                            BoxConstraints(
                              minHeight: rowHeight,
                              maxWidth: tileWidth,
                            ),
                            category,
                          )
                        : SizedBox(
                            width: tileWidth,
                            height: rowHeight,
                            child: Center(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                    verticalDivider ?? const VerticalDivider(width: 0),
                  ],
                )
                .expand((e) => e)
                .toList()
          ],
        ),
      ),
    );
  }
}
