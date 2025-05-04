import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';

/// Abstract base class for all calendar day view implementations
abstract class CalendarDayView<T extends Object> extends Widget {
  const CalendarDayView({super.key});

  /// Create [OverFlowCalendarDayView]
  ///
  /// where event widget can be display overflowed to other time row
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

  /// Create [CategoryCalendarDayView]
  ///
  /// where day view is divided into multiple category with fixed time slot.
  /// event will be showed within the correspond event tile only.
  static CalendarDayView<T> category<T extends Object>({
    required CategoryDavViewConfig config,
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewController? controller,
    CategoryDayViewTileTap? onTileTap,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
  }) =>
      CategoryDayView(
        config: config,
        events: events,
        categories: categories,
        eventBuilder: eventBuilder,
        onTileTap: onTileTap,
        controller: controller,
      );

  /// Create [CategoryOverflowCalendarDayView]
  ///
  /// where day view is divided into multiple category with fixed time slot.
  /// event can be display overflowed into different time slot but within the same category column
  static CalendarDayView<T> categoryOverflow<T extends Object>({
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewTileTap? onTileTap,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
    CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder,
    required CategoryDavViewConfig config,
  }) =>
      Category2DOverflowDayView(
        controller: CategoryDayViewController(),
        config: config,
        events: events,
        categories: categories,
        eventBuilder: eventBuilder,
        onTileTap: onTileTap,
      );

  /// Create [InRowCalendarDayView]
  ///
  /// Show all events that are happened in the same time gap window in a single row
  static CalendarDayView<T> inRow<T extends Object>({
    required List<DayEvent<T>> events,
    DayViewItemBuilder<T>? itemBuilder,
    DayViewTimeRowBuilder<T>? timeRowBuilder,
    OnTimeTap? onTap,
    required InRowDayViewConfig config,
  }) =>
      InRowCalendarDayView(
        events: events,
        itemBuilder: itemBuilder,
        timeRowBuilder: timeRowBuilder,
        onTap: onTap,
        config: config,
      );

  /// Create [EventCalendarDayView]
  ///
  /// this day view doesn't display with a fixed time gap
  /// it listed and sorted by the time that the events start
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
}
