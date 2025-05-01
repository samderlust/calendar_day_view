import 'package:calendar_day_view/src/extensions/date_time_extension.dart';
import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

import '../../../calendar_day_view.dart';
import '../../models/typedef.dart';

class Category2DDayView<T extends Object> extends StatefulWidget implements CalendarDayView<T> {
  const Category2DDayView({
    super.key,
    required this.config,
    required this.categories,
    required this.events,
    required this.eventBuilder,
    this.onTileTap,
    this.controlBarBuilder,
  });

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
  State<Category2DDayView<T>> createState() => _Category2DDayViewState<T>();
}

class _Category2DDayViewState<T extends Object> extends State<Category2DDayView<T>> {
  @override
  Widget build(BuildContext context) {
    final rowLength = MediaQuery.sizeOf(context).width - widget.config.timeColumnWidth;

    final tileWidth = widget.config.allowHorizontalScroll ? rowLength / widget.config.columnsPerPage : rowLength / widget.categories.length;

    return TableView.builder(
      columnCount: widget.categories.length + 1,
      rowCount: widget.config.timeList.length + 1,
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      verticalDetails: const ScrollableDetails(
        direction: AxisDirection.down,
        physics: ClampingScrollPhysics(),
      ),
      horizontalDetails: const ScrollableDetails(
        direction: AxisDirection.right,
        physics: ClampingScrollPhysics(),
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
          extent: FixedTableSpanExtent(index == 0 ? widget.config.timeColumnWidth : tileWidth),
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
          extent: FixedTableSpanExtent(widget.config.rowHeight),
        );
      },
      cellBuilder: (BuildContext context, TableVicinity vicinity) {
        final rowIndex = vicinity.yIndex;
        final columnIndex = vicinity.xIndex;
        // final event = widget.events.firstWhere(
        //   (event) => event.startInThisGap(
        //     widget.config.timeList[rowIndex],
        //     widget.config.timeGap,
        //   ),
        // );
        // return TableViewCell(
        //   child: Text(
        //     "${vicinity.row} | ${vicinity.column} \n ${vicinity.yIndex} | ${vicinity.xIndex}",
        //   ),
        // );

        if (rowIndex == 0 && columnIndex == 0) {
          return TableViewCell(
            child: widget.config.logo ??
                Container(
                  decoration: widget.config.headerDecoration,
                ),
          );
        }

        // building category title
        if (rowIndex == 0 && columnIndex > 0) {
          return buildCategoryTitle(context, widget.categories[columnIndex - 1]);
        }

        if (columnIndex == 0) {
          final time = widget.config.timeList[rowIndex - 1];
          final timeLabel = Padding(
            padding: const EdgeInsets.all(5),
            child: widget.config.timeLabelBuilder?.call(context, time) ??
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    widget.config.time12 ? time.hourDisplay12 : time.hourDisplay24,
                    style: widget.config.timeTextStyle,
                    maxLines: 1,
                  ),
                ),
          );

          return TableViewCell(child: timeLabel);
        }

        final time = widget.config.timeList.elementAt(rowIndex - 1);
        final rowEvents = List<CategorizedDayEvent<T>>.from(widget.events.where(
          (event) => event.startInThisGap(time, widget.config.timeGap),
        ));

        final category = widget.categories.elementAt(columnIndex - 1);

        final cellEvent = rowEvents.firstWhereOrNull((e) => e.categoryId == category.id);

        return switch (cellEvent) {
          final event? => TableViewCell(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: tileWidth,
                  maxWidth: tileWidth,
                  minHeight: widget.config.rowHeight,
                  maxHeight: widget.config.rowHeight,
                ),
                child: widget.eventBuilder(
                  BoxConstraints(
                    maxWidth: tileWidth,
                    maxHeight: widget.config.rowHeight,
                  ),
                  category,
                  time,
                  event,
                ),
              ),
            ),
          _ => TableViewCell(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget.onTileTap == null ? null : () => widget.onTileTap!(category, time),
                child: SizedBox(
                  width: tileWidth,
                  height: widget.config.rowHeight,
                ),
              ),
            ),
        };
      },
    );
  }
}

TableViewCell buildCategoryTitle(BuildContext context, EventCategory category) {
  return TableViewCell(
    child: Center(
      child: Text(
        category.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
