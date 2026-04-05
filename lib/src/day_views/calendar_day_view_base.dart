import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';

/// Abstract base class and factory for all calendar day view widgets.
///
/// Do not extend this class directly. Use the named static constructors to
/// create a specific view type:
///
/// - [CalendarDayView.overflow] — events span across time slots
/// - [CalendarDayView.multiColumn] — overlapping events laid out side-by-side
/// - [CalendarDayView.category] — fixed grid of category columns
/// - [CalendarDayView.categoryOverflow] — category columns with overflow events
/// - [CalendarDayView.inRow] — events in the same time gap grouped in one row
/// - [CalendarDayView.eventOnly] — chronological list of events (no time grid)
abstract class CalendarDayView<T extends Object> extends Widget {
  /// Const constructor for subclasses.
  const CalendarDayView({super.key});

  /// Creates an [OverFlowCalendarDayView] — a time-grid view where events
  /// visually overflow across multiple time rows based on their duration.
  ///
  /// Events with overlapping time ranges are grouped into rows that render
  /// either as fixed-width columns or as horizontally scrollable lists
  /// (see [OverFlowDayViewConfig.renderRowAsListView]).
  ///
  /// [overflowItemBuilder] is required in practice — it is called for each
  /// event tile. [onTimeTap] is optional and fires when the user taps an
  /// empty area of the time grid.
  static CalendarDayView<T> overflow<T extends Object>({
    required List<DayEvent<T>> events,
    DayViewItemBuilder<T>? overflowItemBuilder,
    OnTimeTap? onTimeTap,
    required OverFlowDayViewConfig config,
  }) =>
      OverFlowCalendarDayView<T>(
        events: events,
        overflowItemBuilder: overflowItemBuilder,
        onTimeTap: onTimeTap,
        config: config,
      );

  /// Creates a [CategoryDayView] — a 2D grid where each column represents
  /// an [EventCategory] and each row is a fixed time slot.
  ///
  /// Events are placed into the cell matching their category and time slot.
  /// Only events whose [CategorizedDayEvent.categoryId] matches one of
  /// [categories] are rendered.
  ///
  /// Use [CategoryDavViewConfig.showAllEventsInCell] to render multiple
  /// events per cell side-by-side, and [emptyTileBuilder] to customize
  /// empty cells.
  static CalendarDayView<T> category<T extends Object>({
    required CategoryDavViewConfig config,
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewController? controller,
    CategoryDayViewTileTap? onTimeTap,
    CategoryEmptyTileBuilder? emptyTileBuilder,
  }) =>
      CategoryDayView(
        config: config,
        events: events,
        categories: categories,
        eventBuilder: eventBuilder,
        onTimeTap: onTimeTap,
        emptyTileBuilder: emptyTileBuilder,
        controller: controller,
      );

  /// Creates a [CategoryOverflowDayView] — like [category], but events may
  /// visually overflow into adjacent time slots within the same category
  /// column.
  ///
  /// Useful when events have longer durations than a single time slot.
  static CalendarDayView<T> categoryOverflow<T extends Object>({
    CategoryDayViewController? controller,
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewTileTap? onTimeTap,
    CategoryEmptyTileBuilder? emptyTileBuilder,
    required CategoryDavViewConfig config,
  }) =>
      CategoryOverflowDayView(
        controller: controller,
        config: config,
        events: events,
        categories: categories,
        eventBuilder: eventBuilder,
        onTimeTap: onTimeTap,
        emptyTileBuilder: emptyTileBuilder,
      );

  /// Creates an [InRowCalendarDayView] — a time-grid view where all events
  /// whose start falls within the same time gap are grouped into a single
  /// horizontal row.
  ///
  /// Provide either [itemBuilder] (one event at a time) or [timeRowBuilder]
  /// (all events in the row at once) — not both.
  static CalendarDayView<T> inRow<T extends Object>({
    required List<DayEvent<T>> events,
    DayViewItemBuilder<T>? itemBuilder,
    DayViewTimeRowBuilder<T>? timeRowBuilder,
    OnTimeTap? onTimeTap,
    required InRowDayViewConfig config,
  }) =>
      InRowCalendarDayView(
        events: events,
        itemBuilder: itemBuilder,
        timeRowBuilder: timeRowBuilder,
        onTimeTap: onTimeTap,
        config: config,
      );

  /// Creates an [EventCalendarDayView] — a chronological list of events
  /// without a fixed time grid.
  ///
  /// Only time slots that contain at least one event are rendered, sorted
  /// by start time. Set [EventDayViewConfig.showHourly] to group by hour.
  static CalendarDayView<T> eventOnly<T extends Object>({
    required List<DayEvent<T>> events,
    required EventDayViewItemBuilder<T> eventDayViewItemBuilder,
    IndexedWidgetBuilder? itemSeparatorBuilder,
    required EventDayViewConfig config,
  }) =>
      EventCalendarDayView(
        itemSeparatorBuilder: itemSeparatorBuilder,
        events: events,
        eventDayViewItemBuilder: eventDayViewItemBuilder,
        config: config,
      );

  /// Creates a [MultiColumnCalendarDayView] — a Google Calendar-style
  /// layout where overlapping events are placed side-by-side in columns.
  ///
  /// The number of columns is automatically determined per overlap cluster
  /// by the default greedy interval graph coloring algorithm. Provide
  /// [MultiColumnDayViewConfig.overlapStrategy] to supply a custom layout
  /// algorithm.
  static CalendarDayView<T> multiColumn<T extends Object>({
    required List<DayEvent<T>> events,
    required MultiColumnItemBuilder<T> itemBuilder,
    OnTimeTap? onTimeTap,
    required MultiColumnDayViewConfig<T> config,
  }) =>
      MultiColumnCalendarDayView<T>(
        events: events,
        itemBuilder: itemBuilder,
        onTimeTap: onTimeTap,
        config: config,
      );
}
