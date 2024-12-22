import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../models/typedef.dart';
import '../day_view_config.dart';
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
    this.onTileTap,
    this.controlBarBuilder,
    required this.config,
  }) : super(key: key);

  final CategoryDavViewConfig config;

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
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    final rowLength =
        MediaQuery.sizeOf(context).width - widget.config.timeColumnWidth;

    final tileWidth = widget.config.allowHorizontalScroll
        ? rowLength / widget.config.columnsPerPage
        : rowLength / widget.categories.length;

    final totalWidth = widget.config.allowHorizontalScroll
        ? tileWidth * widget.categories.length
        : rowLength;

    return SafeArea(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
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
                      Text(widget.config.currentDate
                          .toString()
                          .split(":")
                          .first),
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
                    TimeAndLogoWidget(config: widget.config),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: SizedBox(
                          width: totalWidth,
                          child: Column(
                            children: [
                              widget.config.horizontalDivider ??
                                  const Divider(height: 0),
                              CategoryTitleRow(
                                categories: widget.categories,
                                tileWidth: tileWidth,
                                config: widget.config,
                              ),
                              widget.config.horizontalDivider ??
                                  const Divider(height: 0),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.config.timeList.length,
                                separatorBuilder: (context, index) =>
                                    widget.config.horizontalDivider ??
                                    const Divider(height: 0),
                                itemBuilder: (context, index) {
                                  final time =
                                      widget.config.timeList.elementAt(index);
                                  final rowEvents = widget.events
                                      .where(
                                        (event) => event.startInThisGap(
                                            time, widget.config.timeGap),
                                      )
                                      .toList();
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0
                                          ? widget.config.evenRowColor
                                          : widget.config.oddRowColor,
                                    ),
                                    constraints: BoxConstraints(
                                      minHeight: widget.config.rowHeight,
                                    ),
                                    child: DayViewRow<T>(
                                      config: widget.config,
                                      time: time,
                                      categories: widget.categories,
                                      rowEvents: rowEvents,
                                      onTileTap: widget.onTileTap,
                                      tileWidth: tileWidth,
                                      eventBuilder: widget.eventBuilder,
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
