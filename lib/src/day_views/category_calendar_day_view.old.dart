import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:calendar_day_view/src/extensions/time_of_day_extension.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';
import '../utils/date_time_utils.dart';

class CategoryCalendarDayView<T extends Object> extends StatefulWidget {
  const CategoryCalendarDayView({
    Key? key,
    required this.categories,
    required this.events,
    this.startOfDay = const TimeOfDay(hour: 7, minute: 00),
    this.endOfDay = const TimeOfDay(hour: 17, minute: 00),
    required this.currentDate,
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
    this.allowHorizontalScroll = false,
    this.eventColumnWith = 3,
  }) : super(key: key);

  /// List of category
  final List<EventCategory> categories;

  /// List of events
  final List<CategorizedDayEvent<T>> events;

  /// width of the first column where times are displayed
  final double timeColumnWidth;

  /// the date that this dayView is presenting
  final DateTime currentDate;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay endOfDay;

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

  /// if true the day view can be scrolled horizontally to show more categories
  final bool allowHorizontalScroll;

  /// the width of each event column, only has effect when [allowHorizontalScroll] = true
  final double eventColumnWith;

  @override
  State<CategoryCalendarDayView<T>> createState() =>
      _CategoryCalendarDayViewState<T>();
}

class _CategoryCalendarDayViewState<T extends Object>
    extends State<CategoryCalendarDayView<T>> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final timeStart = widget.currentDate.copyTimeAndMinClean(widget.startOfDay);
    final timeEnd = widget.currentDate.copyTimeAndMinClean(widget.endOfDay);

    final timeList = getTimeList(
      timeStart,
      timeEnd,
      widget.timeGap,
    );

    final rowHeight = widget.heightPerMin * widget.timeGap;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // widget.allowHorizontalScroll
        //     ? (widget.categories.length * widget.eventColumnWith +
        //         widget.timeColumnWidth)
        //     :
        // final rowLength = constraints.maxWidth - timeColumnWidth;
        final rowLength = constraints.maxWidth - widget.timeColumnWidth;

        final tileWidth = widget.allowHorizontalScroll
            ? rowLength / widget.eventColumnWith
            : rowLength / widget.categories.length;

        final totalWith = widget.allowHorizontalScroll
            ? widget.timeColumnWidth + tileWidth * widget.categories.length
            : constraints.maxWidth;
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: rowHeight,
                  maxWidth: constraints.maxWidth,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () {
                        controller.animateTo(
                            (controller.offset - rowLength).clamp(0, rowLength),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      icon: Icon(Icons.arrow_left),
                    ),
                    Text(widget.currentDate.toString()),
                    IconButton.filledTonal(
                      onPressed: () {
                        controller.animateTo(
                            (controller.offset + rowLength).clamp(
                                rowLength, controller.position.maxScrollExtent),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      },
                      icon: Icon(Icons.arrow_right),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  physics: widget.allowHorizontalScroll
                      ? null
                      : const NeverScrollableScrollPhysics(),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      // width: constraints.maxWidth,
                      width: totalWith,
                      child: Column(
                        children: [
                          widget.horizontalDivider ?? const Divider(height: 0),
                          DayViewHeader(
                            rowHeight: rowHeight,
                            verticalDivider: widget.verticalDivider,
                            categories: widget.categories,
                            headerTileBuilder: widget.headerTileBuilder,
                            tileWidth: tileWidth,
                            headerDecoration: widget.headerDecoration,
                            timeColumnWidth: widget.timeColumnWidth,
                            logo: widget.logo,
                          ),
                          widget.horizontalDivider ?? const Divider(height: 0),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: timeList.length,
                            separatorBuilder: (context, index) =>
                                widget.horizontalDivider ??
                                const Divider(height: 0),
                            itemBuilder: (context, index) {
                              final time = timeList.elementAt(index);
                              final rowEvents = widget.events
                                  .where(
                                    (event) =>
                                        event.isInThisGap(time, widget.timeGap),
                                  )
                                  .toList();
                              return Container(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? widget.evenRowColor
                                      : widget.oddRowColor,
                                ),
                                constraints: BoxConstraints(
                                  minHeight: rowHeight,
                                ),
                                child: DayViewRow<T>(
                                  time: time,
                                  timeTextStyle: widget.timeTextStyle,
                                  verticalDivider: widget.verticalDivider,
                                  categories: widget.categories,
                                  rowEvents: rowEvents,
                                  onTileTap: widget.onTileTap,
                                  tileWidth: tileWidth,
                                  rowHeight: rowHeight,
                                  eventBuilder: widget.eventBuilder,
                                  timeColumnWidth: widget.timeColumnWidth,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
