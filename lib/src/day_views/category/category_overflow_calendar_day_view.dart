import '../../extensions/date_time_extension.dart';
import '../../extensions/list_extensions.dart';
import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../models/typedef.dart';
import '../../utils/date_time_utils.dart';
import 'widgets/category_title_row.dart';
import 'widgets/time_and_logo_widget.dart';
import 'widgets/time_row_background.dart';

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
    required this.eventBuilder,
    required this.options,
    required this.currentDate,
    this.onTileTap,
    this.controlBarBuilder,
    this.backgroundTimeTileBuilder,
  }) : super(key: key);

  final CategoryDayViewOptions options;

  /// the date that this dayView is presenting
  final DateTime currentDate;

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

  /// Allow user to customize the UI of each time slot in the background.
  final CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder;

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
                        //TIME LABELS COLUMN
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
                        // EVENT VIEW
                        Expanded(
                          child: ClipPath(
                            clipper: VerticalClipper(),
                            child: SingleChildScrollView(
                              controller: controller,
                              clipBehavior: Clip.none,
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
                                          timeColumnWidth: widget
                                              .options.timeTitleColumnWidth,
                                          logo: widget.options.logo,
                                        ),
                                        widget.options.horizontalDivider ??
                                            const Divider(height: 0),
                                        _DayViewBody(
                                          timeList: timeList,
                                          rowHeight: rowHeight,
                                          tileWidth: tileWidth,
                                          evenRowColor:
                                              widget.options.evenRowColor,
                                          oddRowColor:
                                              widget.options.oddRowColor,
                                          rowBuilder:
                                              widget.backgroundTimeTileBuilder,
                                          events: widget.events,
                                          timeColumnWidth: widget
                                              .options.timeTitleColumnWidth,
                                          categories: widget.categories,
                                          verticalDivider:
                                              widget.options.verticalDivider,
                                          timeGap: widget.options.timeGap,
                                          heightPerMin:
                                              widget.options.heightPerMin,
                                          timeTextStyle:
                                              widget.options.timeTextStyle,
                                          eventBuilder: widget.eventBuilder,
                                          horizontalDivider:
                                              widget.options.horizontalDivider,
                                          onTileTap: widget.onTileTap,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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

class VerticalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..addRect(Rect.fromLTRB(0, 0, size.width, size.height + 200));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _DayViewBody<T extends Object> extends StatelessWidget {
  const _DayViewBody({
    super.key,
    required this.timeList,
    required this.rowHeight,
    required this.tileWidth,
    this.evenRowColor,
    this.oddRowColor,
    this.rowBuilder,
    required this.events,
    required this.timeGap,
    required this.heightPerMin,
    this.timeTextStyle,
    this.verticalDivider,
    this.horizontalDivider,
    required this.eventBuilder,
    required this.categories,
    this.onTileTap,
    required this.timeColumnWidth,
  });

  final List<DateTime> timeList;
  final double rowHeight;
  final double tileWidth;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final CategoryBackgroundTimeTileBuilder? rowBuilder;
  final List<CategorizedDayEvent<T>> events;
  final int timeGap;
  final double heightPerMin;
  final TextStyle? timeTextStyle;
  final VerticalDivider? verticalDivider;
  final Divider? horizontalDivider;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final List<EventCategory> categories;
  final CategoryDayViewTileTap? onTileTap;
  final double timeColumnWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TimeRowBackground(
          oddRowColor: oddRowColor,
          evenRowColor: evenRowColor,
          rowHeight: rowHeight,
          timeList: timeList,
          // rowBuilder: rowBuilder,
        ),
        ListView.separated(
          separatorBuilder: (context, index) =>
              horizontalDivider ?? const Divider(height: 0),
          clipBehavior: Clip.none,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: timeList.length,
          itemBuilder: (context, index) {
            final time = timeList.elementAt(index);

            return IntrinsicHeight(
              child: Row(
                children: [
                  ...categories.map(
                    (c) => [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (onTileTap == null)
                            ? null
                            : () => onTileTap!(c, time),
                        child: SizedBox(
                          height: rowHeight,
                          width: tileWidth,
                          child: rowBuilder?.call(
                                context,
                                BoxConstraints(
                                  maxHeight: rowHeight,
                                  maxWidth: tileWidth,
                                ),
                                time,
                                c,
                                index % 2 != 0,
                              ) ??
                              const SizedBox.shrink(),
                        ),
                      ),
                      verticalDivider ?? const VerticalDivider(width: 0),
                    ],
                  )
                ].expand((element) => element).toList(),
              ),
            );
          },
        ),
        for (var event in events)
          Builder(
            builder: (context) {
              final category =
                  categories.firstWhereOrNull((c) => c.id == event.categoryId);
              if (category == null) return const SizedBox.shrink();

              final cateIndex =
                  categories.indexWhere((c) => c.id == event.categoryId);
              if (cateIndex == -1) return const SizedBox.shrink();

              final constraints = BoxConstraints(
                maxHeight: event.durationInMins.toDouble(),
                maxWidth: tileWidth,
              );

              return Positioned(
                top: event.minutesFrom(timeList.first) * heightPerMin,
                left: cateIndex * tileWidth,
                child: eventBuilder(
                  constraints,
                  category,
                  event.start,
                  event,
                ),
              );
            },
          ),
      ],
    );
  }
}
