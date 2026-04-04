import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../../calendar_day_view.dart';
import '../../extensions/date_time_extension.dart';

class CategoryDayView<T extends Object> extends StatelessWidget implements CalendarDayView<T> {
  const CategoryDayView({
    super.key,
    this.controller,
    required this.eventBuilder,
    this.onTimeTap,
    this.emptyTileBuilder,
    required this.events,
    required this.config,
    required this.categories,
  });

  final CategoryDayViewController? controller;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final CategoryDayViewTileTap? onTimeTap;
  final CategoryEmptyTileBuilder? emptyTileBuilder;
  final List<CategorizedDayEvent<T>> events;
  final CategoryDavViewConfig config;
  final List<EventCategory> categories;

  @override
  Widget build(BuildContext context) {
    return _CategoryTableView<T>(
      controller: controller,
      config: config,
      categories: categories,
      events: events,
      eventBuilder: eventBuilder,
      onTimeTap: onTimeTap,
      emptyTileBuilder: emptyTileBuilder,
      overflow: false,
    );
  }
}

class CategoryOverflowDayView<T extends Object> extends StatelessWidget implements CalendarDayView<T> {
  const CategoryOverflowDayView({
    super.key,
    this.controller,
    required this.eventBuilder,
    this.onTimeTap,
    this.emptyTileBuilder,
    required this.events,
    required this.config,
    required this.categories,
  });

  final CategoryDayViewController? controller;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final CategoryDayViewTileTap? onTimeTap;
  final CategoryEmptyTileBuilder? emptyTileBuilder;
  final List<CategorizedDayEvent<T>> events;
  final CategoryDavViewConfig config;
  final List<EventCategory> categories;

  @override
  Widget build(BuildContext context) {
    return _CategoryTableView<T>(
      controller: controller,
      config: config,
      categories: categories,
      events: events,
      eventBuilder: eventBuilder,
      onTimeTap: onTimeTap,
      emptyTileBuilder: emptyTileBuilder,
      overflow: true,
    );
  }
}

class _CategoryTableView<T extends Object> extends StatelessWidget {
  const _CategoryTableView({
    super.key,
    this.controller,
    required this.config,
    required this.categories,
    required this.events,
    required this.eventBuilder,
    this.onTimeTap,
    this.emptyTileBuilder,
    required this.overflow,
  });

  final CategoryDayViewController? controller;
  final CategoryDavViewConfig config;
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> events;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final CategoryDayViewTileTap? onTimeTap;
  final CategoryEmptyTileBuilder? emptyTileBuilder;
  final bool overflow;

  @override
  Widget build(BuildContext context) {
    final eventPartLength = MediaQuery.sizeOf(context).width - config.timeColumnWidth;
    final columnWidth = config.allowHorizontalScroll ? eventPartLength / config.columnsPerPage : eventPartLength / (overflow ? categories.length : config.columnsPerPage);

    controller?.calibrate(
      columnWidth,
      config.columnsPerPage,
    );

    return TableView.builder(
      columnCount: categories.length + 1,
      rowCount: config.timeList.length + 1,
      pinnedColumnCount: 1,
      pinnedRowCount: overflow ? 1 : (config.freezeCategoryTitleRow ? 1 : 0),
      verticalDetails: ScrollableDetails(
        direction: AxisDirection.down,
        physics: const ClampingScrollPhysics(),
        controller: controller?.verticalScrollController,
      ),
      horizontalDetails: ScrollableDetails(
        direction: AxisDirection.right,
        physics: const ClampingScrollPhysics(),
        controller: controller?.horizontalScrollController,
      ),
      columnBuilder: (int index) {
        return TableSpan(
          foregroundDecoration: overflow
              ? null
              : SpanDecoration(
                  border: SpanBorder(
                    trailing: const BorderSide(color: Colors.grey, width: 1),
                    leading: index != 0 ? BorderSide.none : const BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
          backgroundDecoration: overflow
              ? SpanDecoration(
                  border: SpanBorder(
                    trailing: const BorderSide(color: Colors.grey, width: 1),
                    leading: index != 0 ? BorderSide.none : const BorderSide(color: Colors.grey, width: 1),
                  ),
                )
              : null,
          extent: FixedTableSpanExtent(index == 0 ? config.timeColumnWidth : columnWidth),
        );
      },
      rowBuilder: (rowIndex) {
        return TableSpan(
          foregroundDecoration: overflow
              ? null
              : SpanDecoration(
                  border: SpanBorder(
                    trailing: const BorderSide(color: Colors.grey, width: 1),
                    leading: rowIndex != 0 ? BorderSide.none : const BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
          backgroundDecoration: overflow
              ? SpanDecoration(
                  border: SpanBorder(
                    trailing: const BorderSide(color: Colors.grey, width: 1),
                    leading: rowIndex != 0 ? BorderSide.none : const BorderSide(color: Colors.grey, width: 1),
                  ),
                )
              : null,
          extent: FixedTableSpanExtent(config.rowHeight),
        );
      },
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        final rowIndex = vicinity.yIndex;
        final columnIndex = vicinity.xIndex;

        if (rowIndex == 0 && columnIndex == 0) {
          return _buildLogo(context);
        }

        if (rowIndex == 0 && columnIndex > 0) {
          return _buildCategoryTitle(context, categories[columnIndex - 1]);
        }

        if (columnIndex == 0) {
          return _buildTimeLabelColumn(context, rowIndex);
        }

        return _buildEventCell(
          context: context,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          tileWidth: columnWidth,
        );
      },
    );
  }

  TableViewCell _buildTimeLabelColumn(BuildContext context, int rowIndex) {
    final time = config.timeList[rowIndex - 1];
    final timeLabel = Padding(
      padding: const EdgeInsets.all(5),
      child: config.timeLabelBuilder?.call(context, time) ??
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              config.time12 ? time.hourDisplay12 : time.hourDisplay24,
              style: config.timeTextStyle,
              maxLines: 1,
            ),
          ),
    );

    return TableViewCell(child: timeLabel);
  }

  TableViewCell _buildLogo(BuildContext context) {
    return TableViewCell(
      child: config.logo ?? Container(decoration: config.headerDecoration),
    );
  }

  TableViewCell _buildCategoryTitle(BuildContext context, EventCategory category) {
    return TableViewCell(
      child: Center(
        child: Text(
          category.name,
          style: config.categoryTitleTextStyle ?? const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  TableViewCell _buildEventCell({
    required BuildContext context,
    required int rowIndex,
    required int columnIndex,
    required double tileWidth,
  }) {
    final time = config.timeList.elementAt(rowIndex - 1);
    final category = categories.elementAt(columnIndex - 1);
    final cellEvents = List<CategorizedDayEvent<T>>.from(
      events.where((event) => event.startInThisGap(time, config.timeGap) && event.categoryId == category.id),
    );

    if (cellEvents.isEmpty) {
      return _buildEmptyCell(context, category, time, tileWidth);
    }

    if (overflow) {
      return _buildOverflowEventCell(cellEvents, category, time, tileWidth);
    }

    if (config.showAllEventsInCell && cellEvents.length > 1) {
      return _buildMultiEventCell(cellEvents, category, time, tileWidth);
    }

    final cellEvent = cellEvents.first;
    return TableViewCell(
      child: Container(
        constraints: BoxConstraints(
          minWidth: tileWidth,
          maxWidth: tileWidth,
          minHeight: config.rowHeight,
          maxHeight: config.rowHeight,
        ),
        child: eventBuilder(
          BoxConstraints(maxWidth: tileWidth, maxHeight: config.rowHeight),
          category,
          time,
          cellEvent,
        ),
      ),
    );
  }

  TableViewCell _buildEmptyCell(BuildContext context, EventCategory category, DateTime time, double tileWidth) {
    if (emptyTileBuilder != null) {
      return TableViewCell(
        child: emptyTileBuilder!(
          BoxConstraints(maxWidth: tileWidth, maxHeight: config.rowHeight),
          category,
          time,
        ),
      );
    }
    return TableViewCell(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTimeTap == null ? null : () => onTimeTap!(category, time),
        child: SizedBox(
          width: tileWidth,
          height: config.rowHeight,
        ),
      ),
    );
  }

  TableViewCell _buildOverflowEventCell(List<CategorizedDayEvent<T>> cellEvents, EventCategory category, DateTime time, double tileWidth) {
    final cellEvent = cellEvents.first;
    final constraints = BoxConstraints(
      maxHeight: cellEvent.durationInMins * config.heightPerMin,
      maxWidth: tileWidth,
    );
    final top = cellEvent.start.minute * config.heightPerMin;

    return TableViewCell(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: top,
            left: 0,
            child: Container(
              constraints: constraints,
              child: eventBuilder(constraints, category, time, cellEvent),
            ),
          ),
        ],
      ),
    );
  }

  TableViewCell _buildMultiEventCell(List<CategorizedDayEvent<T>> cellEvents, EventCategory category, DateTime time, double tileWidth) {
    final perEventWidth = tileWidth / cellEvents.length;
    return TableViewCell(
      child: Row(
        children: cellEvents.map((event) {
          final constraints = BoxConstraints(
            maxWidth: perEventWidth,
            maxHeight: config.rowHeight,
          );
          return SizedBox(
            width: perEventWidth,
            height: config.rowHeight,
            child: eventBuilder(constraints, category, time, event),
          );
        }).toList(),
      ),
    );
  }
}
