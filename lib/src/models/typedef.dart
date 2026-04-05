import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';

/// Builder for a single event tile inside a time row.
///
/// Provided by views that render multiple events in a row (e.g.,
/// [OverFlowCalendarDayView], [InRowCalendarDayView]).
///
/// - [constraints] is the box the tile should fit into
/// - [itemIndex] is the event's index within its row (useful for alternating
///   styles)
/// - [event] is the event being rendered
typedef DayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  int itemIndex,
  DayEvent<T> event,
);

/// Builder that receives all events in a single time row at once.
///
/// Use this as an alternative to [DayViewItemBuilder] when you want to
/// render the entire row as a single composite widget.
typedef DayViewTimeRowBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  List<DayEvent<T>> events,
);

/// Builder for a single item in [EventCalendarDayView].
///
/// Unlike [DayViewItemBuilder], this view has no time grid — events are
/// listed chronologically and no box constraints are provided.
typedef EventDayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  int itemIndex,
  DayEvent<T> event,
);

/// Callback invoked when the user taps an empty time slot.
///
/// The reported [DateTime] is rounded to the nearest 5 minutes by the view.
typedef OnTimeTap = Function(DateTime time);

/// Builder for a single event cell in the category views
/// ([CategoryDayView] / [CategoryOverflowDayView]).
///
/// - [constraints] is the box the cell should fit into
/// - [category] is the column this event belongs to
/// - [time] is the row start time
/// - [event] is the categorized event to render
typedef CategoryDayViewEventBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  DateTime time,
  CategorizedDayEvent<T> event,
);

/// Callback invoked when the user taps a category cell.
///
/// Provides the category column and row time that were tapped.
typedef CategoryDayViewTileTap<T extends Object> = Function(
  EventCategory category,
  DateTime time,
);

/// Where the time column should be positioned in the day view.
///
/// Used by [DayViewDecoration.timeColumnPosition]. Supported in overflow,
/// multi-column, in-row, and event-only views. The category views always
/// keep the time column pinned on the left regardless of this value.
enum TimeColumnPosition {
  /// Time column on the left (default).
  left,

  /// Time column on the right.
  right,

  /// No time column — labels are hidden and events take the full width.
  none,
}

/// Builder for a custom time label widget shown next to each time row.
///
/// If null, the default label (12h or 24h text based on
/// [DavViewConfig.time12]) is used.
typedef TimeLabelBuilder = Widget Function(BuildContext context, DateTime time);

/// Simple builder for [DayViewDecoration.header] and
/// [DayViewDecoration.footer] — returns a widget rendered above or below the
/// scrollable time grid.
typedef DayViewSectionBuilder = Widget Function(BuildContext context);

/// Builder for a fully custom current time line widget.
///
/// [top] is the vertical offset (in logical pixels) at which the line
/// should be rendered relative to the day start, and [width] is the
/// available horizontal width.
typedef CurrentTimeLineBuilder = Widget Function(double top, double width);

/// Builder for a custom background widget per time row.
///
/// Useful for shading specific time ranges such as lunch break, working
/// hours, or unavailable blocks.
///
/// - [rowTime] is the start time of the row
/// - [constraints] is the row's full size (`width` × `rowHeight`)
///
/// Return `null` to use the default (transparent) background for a given row.
typedef TimeRowBackgroundBuilder = Widget? Function(
  BuildContext context,
  DateTime rowTime,
  BoxConstraints constraints,
);

/// Builder for a custom divider widget between time rows.
///
/// - [rowTime] is the start time of the row this divider precedes
///
/// Return `null` to skip the divider for a specific row. If this builder
/// itself is `null`, the default divider is used.
typedef DividerBuilder = Widget? Function(
  BuildContext context,
  DateTime rowTime,
);

/// Builder for a single event tile in [MultiColumnCalendarDayView].
///
/// Receives the tile's [constraints], the [event] to render, and its
/// assigned [columnIndex] and [totalColumns] within its overlap cluster.
/// Use these to style events differently based on column position
/// (e.g., alternating colors).
typedef MultiColumnItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  DayEvent<T> event,
  int columnIndex,
  int totalColumns,
);

/// Custom overlap layout strategy for [MultiColumnCalendarDayView].
///
/// Receives the flat list of [events] and must return a list of
/// [ColumnEvent] describing the column assignment for each event. Use this
/// to implement layout algorithms that differ from the default greedy
/// interval graph coloring — for example, to prefer wider events,
/// stack everything in a single column, or apply custom tie-breaking.
///
/// [startOfDay] and [endOfDay] are the visible time bounds; events outside
/// the range are typically filtered out.
typedef OverlapStrategy<T extends Object> = List<ColumnEvent<T>> Function(
  List<DayEvent<T>> events, {
  DateTime? startOfDay,
  DateTime? endOfDay,
});

/// Builder for an empty cell in the category views
/// ([CategoryDayView] / [CategoryOverflowDayView]).
///
/// When provided, replaces the default empty [SizedBox] placeholder —
/// useful for rendering "Available" labels, background patterns, or
/// interactive add-event hints.
typedef CategoryEmptyTileBuilder<T extends Object> = Widget Function(
  BoxConstraints constraints,
  EventCategory category,
  DateTime time,
);
