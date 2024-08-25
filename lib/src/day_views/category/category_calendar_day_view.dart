import '../../extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../models/typedef.dart';
import '../../utils/date_time_utils.dart';
import 'widgets/category_title_row.dart';
import 'widgets/day_view_row.dart';
import 'widgets/time_and_logo_widget.dart';

/// CategoryCalendarDayView
/// where day view is divided into multiple category with fixed time slot.
/// events will be showed within the correspond event tile only.

class CategoryCalendarDayView<T extends Object> extends StatefulWidget
    implements CalendarDayView<T> {
  const CategoryCalendarDayView({
    Key? key,
    required this.categories,
    required this.events,
    required this.eventBuilder,
    required this.options,
    this.onTileTap,
    this.controlBarBuilder,
    required this.currentDate,
  }) : super(key: key);

  /// the date that this dayView is presenting
  final DateTime currentDate;

  final CategoryDayViewOptions options;

  /// List of category
  final List<EventCategory> categories;

  /// List of events
  final List<CategorizedDayEvent<T>> events;

  /// event builder
  final CategoryDayViewEventBuilder<T> eventBuilder;

  /// call when you tap on an empty tile
  ///
  /// provide [EventCategory] and [DateTime]  of that tile
  final CategoryDayViewTileTap? onTileTap;

  /// To build the controller bar on the top of the day view
  ///
  /// `goToPreviousTab` to animate to previous tabs
  /// `goToNextTab` to animate to next tabs
  final CategoryDayViewControlBarBuilder? controlBarBuilder;

  @override
  State<CategoryCalendarDayView<T>> createState() =>
      _CategoryCalendarDayViewState<T>();
}

class _CategoryCalendarDayViewState<T extends Object>
    extends State<CategoryCalendarDayView<T>> {
  late ScrollController _hController;
  late ScrollController _vController;
  @override
  void initState() {
    super.initState();
    _hController = ScrollController();
    _vController = ScrollController();
  }

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeStart =
        widget.currentDate.copyTimeAndMinClean(widget.options.startOfDay);
    final timeEnd =
        widget.currentDate.copyTimeAndMinClean(widget.options.endOfDay);

    final timeList = getTimeList(
      timeStart,
      timeEnd,
      widget.options.timeGap,
    );

    final rowHeight = widget.options.heightPerMin * widget.options.timeGap;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowLength =
              constraints.maxWidth - widget.options.timeTitleColumnWidth;

          final tileWidth = widget.options.allowHorizontalScroll
              ? rowLength / widget.options.columnsPerPage
              : rowLength / widget.categories.length;

          final totalWidth = widget.options.allowHorizontalScroll
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
                        TimeAndLogoWidget(
                          time12: widget.options.time12,
                          rowHeight: rowHeight,
                          timeColumnWidth: widget.options.timeTitleColumnWidth,
                          timeList: timeList,
                          evenRowColor: widget.options.evenRowColor,
                          oddRowColor: widget.options.oddRowColor,
                          headerDecoration: widget.options.headerDecoration,
                          horizontalDivider: widget.options.horizontalDivider,
                          verticalDivider: widget.options.verticalDivider,
                          logo: widget.options.logo,
                          timeTextStyle: widget.options.timeTextStyle,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _hController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            child: SizedBox(
                              width: totalWidth,
                              child: Column(
                                children: [
                                  widget.options.horizontalDivider ??
                                      const Divider(height: 0),
                                  CategoryTitleRow(
                                    rowHeight: rowHeight,
                                    verticalDivider:
                                        widget.options.verticalDivider,
                                    categories: widget.categories,
                                    tileWidth: tileWidth,
                                    headerDecoration:
                                        widget.options.headerDecoration,
                                    timeColumnWidth:
                                        widget.options.timeTitleColumnWidth,
                                    logo: widget.options.logo,
                                  ),
                                  widget.options.horizontalDivider ??
                                      const Divider(height: 0),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: timeList.length,
                                    separatorBuilder: (context, index) =>
                                        widget.options.horizontalDivider ??
                                        const Divider(height: 0),
                                    itemBuilder: (context, index) {
                                      final time = timeList.elementAt(index);
                                      final rowEvents = widget.events
                                          .where(
                                            (event) => event.startInThisGap(
                                                time, widget.options.timeGap),
                                          )
                                          .toList();
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: index % 2 == 0
                                              ? widget.options.evenRowColor
                                              : widget.options.oddRowColor,
                                        ),
                                        constraints: BoxConstraints(
                                          minHeight: rowHeight,
                                        ),
                                        child: DayViewRow<T>(
                                          time: time,
                                          timeTextStyle:
                                              widget.options.timeTextStyle,
                                          verticalDivider:
                                              widget.options.verticalDivider,
                                          categories: widget.categories,
                                          rowEvents: rowEvents,
                                          onTileTap: widget.onTileTap,
                                          tileWidth: tileWidth,
                                          rowHeight: rowHeight,
                                          eventBuilder: widget.eventBuilder,
                                          timeColumnWidth: widget
                                              .options.timeTitleColumnWidth,
                                        ),
                                      );
                                    },
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
    _hController.animateTo(
      (_hController.offset - rowLength).clamp(0, totalWidth),
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void goNext(double rowLength, double totalWidth) {
    _hController.animateTo(
      (_hController.offset + rowLength).clamp(rowLength, totalWidth),
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
