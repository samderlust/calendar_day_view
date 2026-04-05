import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';

typedef DayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,

  ///index of the item in same row
  int itemIndex,
  DayEvent<T> event,
);

typedef DayViewTimeRowBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  List<DayEvent<T>> events,
);

typedef EventDayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  int itemIndex,
  DayEvent<T> event,
);

typedef OnTimeTap = Function(DateTime time);

typedef CategoryDayViewEventBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  DateTime time,
  CategorizedDayEvent<T> event,
);
typedef CategoryDayViewTileTap<T extends Object> = Function(
  EventCategory category,
  DateTime time,
);

/// Where the time column should be positioned in the day view
enum TimeColumnPosition {
  /// Time column on the left (default)
  left,

  /// Time column on the right
  right,

  /// No time column (labels hidden, events take full width)
  none,
}

/// time label builder
/// allow custom time label
typedef TimeLabelBuilder = Widget Function(BuildContext context, DateTime time);

/// Simple section builder for headers and footers
typedef DayViewSectionBuilder = Widget Function(BuildContext context);

/// current time line builder
/// allow custom current time line widget
typedef CurrentTimeLineBuilder = Widget Function(double top, double width);

/// time row background builder
/// allow custom background per time row (e.g. shade lunch break or working hours)
///
/// [rowTime] is the start time of the row
/// [constraints] provides the row's full size (width, height = rowHeight)
typedef TimeRowBackgroundBuilder = Widget? Function(
  BuildContext context,
  DateTime rowTime,
  BoxConstraints constraints,
);

/// divider builder
/// allow custom divider between time rows
///
/// [rowTime] is the start time of the row this divider precedes
/// Return null to skip the divider for this row
typedef DividerBuilder = Widget? Function(
  BuildContext context,
  DateTime rowTime,
);

/// builder for multi-column day view events
typedef MultiColumnItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  DayEvent<T> event,
  int columnIndex,
  int totalColumns,
);

/// Custom overlap layout strategy for multi-column view.
///
/// Takes a list of events and returns a list of [ColumnEvent] with column assignments.
/// Users can implement their own layout algorithm (e.g., prefer wider events,
/// different cluster boundaries, custom tie-breaking).
typedef OverlapStrategy<T extends Object> = List<ColumnEvent<T>> Function(
  List<DayEvent<T>> events, {
  DateTime? startOfDay,
  DateTime? endOfDay,
});

/// empty tile builder for category views
/// allow custom empty cell widget
typedef CategoryEmptyTileBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  DateTime time,
);

