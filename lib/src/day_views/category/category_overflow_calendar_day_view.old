import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../extensions/list_extensions.dart';
import '../../models/typedef.dart';
import 'widgets/category_title_row.dart';
import 'widgets/time_and_logo_widget.dart';
import 'widgets/time_row_background.dart';

///CategoryOverflowCalendarDayView
///
/// where day view is divided into multiple category with fixed time slot.
/// events can be display overflowed into different time slot but within the same category column
class CategoryOverflowCalendarDayView<T extends Object> extends StatefulWidget implements CalendarDayView<T> {
  const CategoryOverflowCalendarDayView({
    Key? key,
    required this.categories,
    required this.events,
    required this.eventBuilder,
    this.onTileTap,
    this.controlBarBuilder,
    this.backgroundTimeTileBuilder,
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

  /// Allow user to customize the UI of each time slot in the background.
  final CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder;

  /// To build the controller bar on the top of the day view
  ///
  /// `goToPreviousTab` to animate to previous tabs
  /// `goToNextTab` to animate to next tabs
  final CategoryDayViewControlBarBuilder? controlBarBuilder;
  @override
  State<CategoryOverflowCalendarDayView<T>> createState() => _CategoryOverflowCalendarDayViewState<T>();
}

class _CategoryOverflowCalendarDayViewState<T extends Object> extends State<CategoryOverflowCalendarDayView<T>> {
  late ScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final rowLength = constraints.maxWidth - widget.config.timeColumnWidth;

          final tileWidth = widget.config.allowHorizontalScroll ? rowLength / widget.config.columnsPerPage : rowLength / widget.categories.length;

          final totalWidth = widget.config.allowHorizontalScroll ? tileWidth * widget.categories.length : rowLength;

          return ScrollConfiguration(
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
                          Text(widget.config.currentDate.toString().split(":").first),
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
                        TimeAndLogoWidget(config: widget.config),
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
                                        widget.config.horizontalDivider ?? const Divider(height: 0),
                                        CategoryTitleRow(
                                          tileWidth: tileWidth,
                                          categories: widget.categories,
                                          config: widget.config,
                                        ),
                                        widget.config.horizontalDivider ?? const Divider(height: 0),
                                        _DayViewBody(
                                          tileWidth: tileWidth,
                                          rowBuilder: widget.backgroundTimeTileBuilder,
                                          events: widget.events,
                                          categories: widget.categories,
                                          eventBuilder: widget.eventBuilder,
                                          onTileTap: widget.onTileTap,
                                          config: widget.config,
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
    Path path = Path()..addRect(Rect.fromLTRB(0, 0, size.width, size.height + 200));
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
    this.rowBuilder,
    required this.events,
    required this.eventBuilder,
    required this.categories,
    this.onTileTap,
    required this.tileWidth,
    required this.config,
  });
  final CategoryDavViewConfig config;
  final double tileWidth;

  final CategoryBackgroundTimeTileBuilder? rowBuilder;
  final List<CategorizedDayEvent<T>> events;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final List<EventCategory> categories;
  final CategoryDayViewTileTap? onTileTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TimeRowBackground(
          oddRowColor: config.oddRowColor,
          evenRowColor: config.evenRowColor,
          rowHeight: config.rowHeight,
          timeList: config.timeList,
          // rowBuilder: rowBuilder,
        ),
        ListView.separated(
          separatorBuilder: (context, index) => config.horizontalDivider ?? const Divider(height: 0),
          clipBehavior: Clip.none,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: config.timeList.length,
          itemBuilder: (context, index) {
            final time = config.timeList.elementAt(index);

            return IntrinsicHeight(
              child: Row(
                children: [
                  ...categories.map(
                    (c) => [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (onTileTap == null) ? null : () => onTileTap!(c, time),
                        child: SizedBox(
                          height: config.rowHeight,
                          width: tileWidth,
                          child: rowBuilder?.call(
                                context,
                                BoxConstraints(
                                  maxHeight: config.rowHeight,
                                  maxWidth: tileWidth,
                                ),
                                time,
                                c,
                                index % 2 != 0,
                              ) ??
                              const SizedBox.shrink(),
                        ),
                      ),
                      config.verticalDivider ?? const VerticalDivider(width: 0),
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
              final category = categories.firstWhereOrNull((c) => c.id == event.categoryId);
              if (category == null) return const SizedBox.shrink();

              final cateIndex = categories.indexWhere((c) => c.id == event.categoryId);
              if (cateIndex == -1) return const SizedBox.shrink();

              final constraints = BoxConstraints(
                maxHeight: event.durationInMins * config.heightPerMin,
                maxWidth: tileWidth,
              );

              return Positioned(
                top: event.minutesFrom(config.timeList.first) * config.heightPerMin,
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
