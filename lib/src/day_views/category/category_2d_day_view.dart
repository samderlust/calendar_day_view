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

        if (rowIndex == 0 && columnIndex == 0) {
          return _buildLogo(context, widget.config);
        }

        // building category title
        if (rowIndex == 0 && columnIndex > 0) {
          return _buildCategoryTitle(context, widget.categories[columnIndex - 1]);
        }

        if (columnIndex == 0) {
          return _buildTimeLabelColumn(context, widget.config, rowIndex);
        }

        return _buildEventCell(
          context: context,
          config: widget.config,
          rowIndex: rowIndex,
          columnIndex: columnIndex,
          tileWidth: tileWidth,
          events: widget.events,
          categories: widget.categories,
          eventBuilder: widget.eventBuilder,
          onTileTap: widget.onTileTap,
        );
      },
    );
  }
}

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

class CategoryDayViewController {
  CategoryDayViewController({
    ScrollController? horizontalScrollController,
    ScrollController? verticalScrollController,
  })  : _horizontalScrollController = horizontalScrollController ?? ScrollController(),
        _verticalScrollController = verticalScrollController ?? ScrollController();

  final ScrollController _horizontalScrollController;
  final ScrollController _verticalScrollController;

  double _tabLength = 0;
  double _columnWidth = 0;

  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
  }

  void calbliate(double columnLength, int columnsPerPage) {
    _columnWidth = columnLength;
    _tabLength = columnLength * columnsPerPage;
  }

  void goToPreviousTab() {
    final currentTabLength = _tabLength;
    final newIndex = _horizontalScrollController.offset - currentTabLength;
    _horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void goToNextTab() {
    final currentTabLength = _tabLength;
    final newIndex = _horizontalScrollController.offset + currentTabLength;
    _horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void goToColumn(int index) {
    final newIndex = index * _columnWidth;
    _horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
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
        controller: controller._verticalScrollController,
      ),
      horizontalDetails: ScrollableDetails(
        direction: AxisDirection.right,
        physics: const ClampingScrollPhysics(),
        controller: controller._horizontalScrollController,
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
