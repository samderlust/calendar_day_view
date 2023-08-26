import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:calendar_day_view/src/extensions/time_of_day_extension.dart';
import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../models/typedef.dart';
import '../../utils/date_time_utils.dart';
import 'widgets/time_and_logo_widget.dart';

///CategoryOverflowCalendarDayView
///
/// where day view is divided into multiple category with fixed time slot.
/// events can be display overflowed into different time slot but within the same category column
class CategoryOverflowCalendarDayView<T extends Object> extends StatefulWidget
    implements CalendarDayView<T> {
  const CategoryOverflowCalendarDayView({
    Key? key,
    required this.categories,
    required this.events,
    this.startOfDay = const TimeOfDay(hour: 7, minute: 00),
    this.endOfDay = const TimeOfDay(hour: 17, minute: 00),
    required this.currentDate,
    this.timeGap = 60,
    this.heightPerMin = 1.0,
    this.evenRowColor,
    this.oddRowColor,
    this.verticalDivider,
    this.horizontalDivider,
    this.timeTextStyle,
    required this.eventBuilder,
    this.onTileTap,
    this.headerDecoration,
    this.logo,
    this.timeColumnWidth = 50,
    this.allowHorizontalScroll = false,
    this.columnsPerPage = 3,
    this.controlBarBuilder,
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
  // final CategoryDayViewHeaderTileBuilder? headerTileBuilder;

  /// header row decoration
  final BoxDecoration? headerDecoration;

  /// The widget that will be place at top left corner tile of this day view
  final Widget? logo;

  /// if true the day view can be scrolled horizontally to show more categories
  final bool allowHorizontalScroll;

  /// number of columns per page, only affect when [allowHorizontalScroll] = true
  final double columnsPerPage;

  /// To build the controller bar on the top of the day view
  ///
  /// `goToPreviousTab` to animate to previous tabs
  /// `goToNextTab` to animate to next tabs
  final CategoryDayViewControlBarBuilder? controlBarBuilder;

  @override
  State<CategoryOverflowCalendarDayView<T>> createState() =>
      _CategoryOverflowCalendarDayViewState<T>();
}

class _CategoryOverflowCalendarDayViewState<T extends Object>
    extends State<CategoryOverflowCalendarDayView<T>> {
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
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowLength = constraints.maxWidth - widget.timeColumnWidth;

          final tileWidth = widget.allowHorizontalScroll
              ? rowLength / widget.columnsPerPage
              : rowLength / widget.categories.length;

          final totalWidth = widget.allowHorizontalScroll
              ? tileWidth * widget.categories.length
              : rowLength;

          return ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Column(
              children: [
                (widget.controlBarBuilder != null)
                    ? widget.controlBarBuilder!(
                        () => goBack(rowLength, totalWidth),
                        () => goNext(rowLength, totalWidth),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => goBack(rowLength, totalWidth),
                            icon: const Icon(Icons.arrow_left),
                          ),
                          Text(widget.currentDate.toString().split(":").first),
                          IconButton.filledTonal(
                            onPressed: () => goNext(rowLength, totalWidth),
                            icon: const Icon(Icons.arrow_right),
                          ),
                        ],
                      ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Row(
                      children: [
                        //TIME LABELS COLUMN
                        TimeAndLogoWidget(
                          rowHeight: rowHeight,
                          timeColumnWidth: widget.timeColumnWidth,
                          timeList: timeList,
                          evenRowColor: widget.evenRowColor,
                          oddRowColor: widget.oddRowColor,
                          headerDecoration: widget.headerDecoration,
                          horizontalDivider: widget.horizontalDivider,
                          verticalDivider: widget.verticalDivider,
                          logo: widget.logo,
                          timeTextStyle: widget.timeTextStyle,
                        ),
                        // EVENT VIEW
                        Expanded(
                          child: SingleChildScrollView(
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            // physics: const NeverScrollableScrollPhysics(),
                            child: SizedBox(
                              width: totalWidth,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Column(
                                    children: [
                                      widget.horizontalDivider ??
                                          const Divider(height: 0),
                                      CategoryTitleRow(
                                        rowHeight: rowHeight,
                                        verticalDivider: widget.verticalDivider,
                                        categories: widget.categories,
                                        tileWidth: tileWidth,
                                        headerDecoration:
                                            widget.headerDecoration,
                                        timeColumnWidth: widget.timeColumnWidth,
                                        logo: widget.logo,
                                      ),
                                      widget.horizontalDivider ??
                                          const Divider(height: 0),
                                      Stack(
                                        children: [
                                          TimeRowBackground(
                                            rowNumber: timeList.length,
                                            oddRowColor: widget.oddRowColor,
                                            evenRowColor: widget.evenRowColor,
                                            rowHeight: rowHeight,
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: timeList.length,
                                            itemBuilder: (context, index) {
                                              final time =
                                                  timeList.elementAt(index);
                                              final rowEvents = widget.events
                                                  .where(
                                                    (event) =>
                                                        event.startInThisGap(
                                                            time,
                                                            widget.timeGap),
                                                  )
                                                  .toList();
                                              return DayViewRow<T>(
                                                heightPerMin:
                                                    widget.heightPerMin,
                                                time: time,
                                                timeTextStyle:
                                                    widget.timeTextStyle,
                                                verticalDivider:
                                                    widget.verticalDivider,
                                                horizontalDivider:
                                                    widget.horizontalDivider,
                                                categories: widget.categories,
                                                rowEvents: rowEvents,
                                                onTileTap: widget.onTileTap,
                                                tileWidth: tileWidth,
                                                rowHeight: rowHeight,
                                                eventBuilder:
                                                    widget.eventBuilder,
                                                timeColumnWidth:
                                                    widget.timeColumnWidth,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void goBack(double rowLength, double totalWidth) {
    controller.animateTo(
      (controller.offset - rowLength).clamp(0, totalWidth),
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void goNext(double rowLength, double totalWidth) {
    controller.animateTo(
      (controller.offset + rowLength).clamp(rowLength, totalWidth),
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}

class TimeRowBackground extends StatelessWidget {
  const TimeRowBackground({
    super.key,
    required this.rowNumber,
    required this.evenRowColor,
    required this.oddRowColor,
    required this.rowHeight,
  });

  final int rowNumber;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rowNumber,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? evenRowColor : oddRowColor,
          ),
          constraints: BoxConstraints(minHeight: rowHeight),
        );
      },
    );
  }
}

class DayViewRow<T extends Object> extends StatelessWidget {
  const DayViewRow({
    super.key,
    required this.heightPerMin,
    required this.time,
    required this.timeTextStyle,
    required this.horizontalDivider,
    required this.verticalDivider,
    required this.categories,
    required this.rowEvents,
    required this.onTileTap,
    required this.tileWidth,
    required this.rowHeight,
    required this.eventBuilder,
    required this.timeColumnWidth,
  });

  final double heightPerMin;
  final DateTime time;
  final TextStyle? timeTextStyle;
  final VerticalDivider? verticalDivider;
  final Divider? horizontalDivider;
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
      child: SizedBox(
        height: rowHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            //background
            Column(
              children: [
                SizedBox(height: rowHeight),
                horizontalDivider ?? const Divider(height: 0),
              ],
            ),
            //data
            Row(
              children: [
                ...categories
                    .map((category) {
                      final event = rowEvents
                          .firstWhereOrNull((e) => e.categoryId == category.id);

                      final constraints = BoxConstraints(
                          maxHeight: rowHeight, maxWidth: tileWidth);

                      final eventHeight = switch (event) {
                        var e? => e.durationInMins,
                        _ => rowHeight,
                      }
                          .toDouble();

                      final topGap = switch (event) {
                        var e? => e.minutesFrom(time) * heightPerMin,
                        _ => 0.0,
                      }
                          .toDouble()
                          .abs();

                      return [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (onTileTap == null || event != null)
                              ? null
                              : () => onTileTap!(category, time),
                          child: Container(
                            // color: Colors.primaries[
                            //     Random().nextInt(Colors.primaries.length)],
                            constraints: BoxConstraints(
                              minWidth: tileWidth,
                              maxWidth: tileWidth,
                              maxHeight: eventHeight + topGap,
                              // minHeight: rowHeight,
                            ),
                            child: SizedBox(
                              height: rowHeight,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: topGap,
                                    child: eventBuilder(
                                      constraints,
                                      category,
                                      time,
                                      event,
                                    ),
                                  ),
                                ],
                              ),
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
          ],
        ),
      ),
    );
  }
}

class CategoryTitleRow extends StatelessWidget {
  const CategoryTitleRow({
    super.key,
    required this.rowHeight,
    required this.verticalDivider,
    required this.categories,
    required this.tileWidth,
    this.headerDecoration,
    required this.timeColumnWidth,
    this.logo,
  });

  final double rowHeight;
  final VerticalDivider? verticalDivider;
  final List<EventCategory> categories;
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
            ...categories
                .map(
                  (category) => [
                    SizedBox(
                      width: tileWidth,
                      height: rowHeight,
                      child: Center(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
