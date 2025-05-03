import 'package:calendar_day_view/src/day_views/category/category_day_view_controller.dart';
import 'package:calendar_day_view/src/extensions/date_time_extension.dart';
import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../../calendar_day_view.dart';
import '../../models/typedef.dart';

TableViewCell _buildTimeLabelColumn(BuildContext context, CategoryDavViewConfig config, int rowIndex) {
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

TableViewCell _buildLogo(BuildContext context, CategoryDavViewConfig config) {
  return TableViewCell(
    child: config.logo ?? Container(decoration: config.headerDecoration),
  );
}

TableViewCell _buildCategoryTitle(BuildContext context, EventCategory category) {
  return TableViewCell(
    child: Center(
      child: Text(
        category.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

TableViewCell _buildEventCell<T extends Object>({
  required BuildContext context,
  required CategoryDavViewConfig config,
  required int rowIndex,
  required int columnIndex,
  required double tileWidth,
  required List<CategorizedDayEvent<T>> events,
  required List<EventCategory> categories,
  required CategoryDayViewEventBuilder<T> eventBuilder,
  CategoryDayViewTileTap? onTileTap,
}) {
  final time = config.timeList.elementAt(rowIndex - 1);
  final rowEvents = List<CategorizedDayEvent<T>>.from(events.where(
    (event) => event.startInThisGap(time, config.timeGap),
  ));

  final category = categories.elementAt(columnIndex - 1);

  final cellEvent = rowEvents.firstWhereOrNull((e) => e.categoryId == category.id);

  return switch (cellEvent) {
    final event? => TableViewCell(
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
            event,
          ),
        ),
      ),
    _ => TableViewCell(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTileTap == null ? null : () => onTileTap!(category, time),
          child: SizedBox(
            width: tileWidth,
            height: config.rowHeight,
          ),
        ),
      ),
  };
}

class CategoryDayView2<T extends Object> extends StatelessWidget implements CalendarDayView<T> {
  const CategoryDayView2({
    super.key,
    required this.controller,
    required this.eventBuilder,
    required this.onTileTap,
    required this.events,
    required this.config,
    required this.categories,
  });

  final CategoryDayViewController controller;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final CategoryDayViewTileTap? onTileTap;
  final List<CategorizedDayEvent<T>> events;
  final CategoryDavViewConfig config;
  final List<EventCategory> categories;

  @override
  Widget build(BuildContext context) {
    final eventPartLength = MediaQuery.sizeOf(context).width - config.timeColumnWidth;
    final columnWidth = config.allowHorizontalScroll ? eventPartLength / config.columnsPerPage : eventPartLength / categories.length;

    controller.calbliate(
      columnWidth,
      config.columnsPerPage,
    );

    return TableView.builder(
      columnCount: categories.length + 1,
      rowCount: config.timeList.length + 1,
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      verticalDetails: ScrollableDetails(
        direction: AxisDirection.down,
        physics: const ClampingScrollPhysics(),
        controller: controller.verticalScrollController,
      ),
      horizontalDetails: ScrollableDetails(
        direction: AxisDirection.right,
        physics: const ClampingScrollPhysics(),
        controller: controller.horizontalScrollController,
      ),
      columnBuilder: (int index) {
        return TableSpan(
          foregroundDecoration: SpanDecoration(
            border: SpanBorder(
              trailing: const BorderSide(color: Colors.grey, width: 1),
              leading: index != 0 //only draw border on the left of the first column
                  ? BorderSide.none
                  : const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          extent: FixedTableSpanExtent(index == 0 ? config.timeColumnWidth : columnWidth),
        );
      },
      rowBuilder: (rowIndex) {
        return TableSpan(
          foregroundDecoration: SpanDecoration(
            border: SpanBorder(
              trailing: const BorderSide(color: Colors.grey, width: 1),
              leading: rowIndex != 0 //only draw border on the top of the first row
                  ? BorderSide.none
                  : const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          extent: FixedTableSpanExtent(config.rowHeight),
        );
      },
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        final rowIndex = vicinity.yIndex;
        final columnIndex = vicinity.xIndex;

        if (rowIndex == 0 && columnIndex == 0) {
          return _buildLogo(context, config);
        }

        // building category title
        if (rowIndex == 0 && columnIndex > 0) {
          return _buildCategoryTitle(context, categories[columnIndex - 1]);
        }

        if (columnIndex == 0) {
          return _buildTimeLabelColumn(context, config, rowIndex);
        }

        return _buildEventCell<T>(
          context: context,
          config: config,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          tileWidth: columnWidth,
          events: events,
          categories: categories,
          eventBuilder: eventBuilder,
          onTileTap: onTileTap,
        );
      },
    );
  }
}
