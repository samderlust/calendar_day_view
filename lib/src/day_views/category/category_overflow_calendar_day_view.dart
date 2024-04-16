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
    this.backgroundTimeTileBuilder,
    this.time12 = false,
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

  /// Allow user to customize the UI of each time slot in the background.
  final CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder;

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

  /// show time in 12 hour format
  final bool time12;
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
                          time12: widget.time12,
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
                                        widget.horizontalDivider ??
                                            const Divider(height: 0),
                                        CategoryTitleRow(
                                          rowHeight: rowHeight,
                                          verticalDivider:
                                              widget.verticalDivider,
                                          categories: widget.categories,
                                          tileWidth: tileWidth,
                                          headerDecoration:
                                              widget.headerDecoration,
                                          timeColumnWidth:
                                              widget.timeColumnWidth,
                                          logo: widget.logo,
                                        ),
                                        widget.horizontalDivider ??
                                            const Divider(height: 0),
                                        _DayViewBody(
                                          timeList: timeList,
                                          rowHeight: rowHeight,
                                          tileWidth: tileWidth,
                                          evenRowColor: widget.evenRowColor,
                                          oddRowColor: widget.oddRowColor,
                                          rowBuilder:
                                              widget.backgroundTimeTileBuilder,
                                          events: widget.events,
                                          timeColumnWidth:
                                              widget.timeColumnWidth,
                                          categories: widget.categories,
                                          verticalDivider:
                                              widget.verticalDivider,
                                          timeGap: widget.timeGap,
                                          heightPerMin: widget.heightPerMin,
                                          timeTextStyle: widget.timeTextStyle,
                                          eventBuilder: widget.eventBuilder,
                                          horizontalDivider:
                                              widget.horizontalDivider,
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
