import 'package:calendar_day_view/src/day_views/category/category_overflow_calendar_day_view.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';

abstract class CalendarDayView<T extends Object> extends Widget {
  /// Create [OverFlowCalendarDayView]
  ///
  /// where event widget can be display overflowed to other time row

  factory CalendarDayView.overflow({
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
  factory CalendarDayView.category({
    required CategoryDavViewConfig config,
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewTileTap? onTileTap,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
  }) =>
      CategoryCalendarDayView(
        config: config,
        events: events,
        categories: categories,
        eventBuilder: eventBuilder,
        onTileTap: onTileTap,
        controlBarBuilder: controlBarBuilder,
      );

  /// Create [CategoryOverflowCalendarDayView]
  ///
  /// where day view is divided into multiple category with fixed time slot.
  /// event can be display overflowed into different time slot but within the same category column
  factory CalendarDayView.categoryOverflow({
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewTileTap? onTileTap,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
    CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder,
    required CategoryDavViewConfig config,
  }) =>
      CategoryOverflowCalendarDayView(
        config: config,
        events: events,
        categories: categories,
        eventBuilder: eventBuilder,
        onTileTap: onTileTap,
        controlBarBuilder: controlBarBuilder,
        backgroundTimeTileBuilder: backgroundTimeTileBuilder,
      );

  /// Create [InRowCalendarDayView]
  ///
  /// Show all events that are happened in the same time gap window in a single row
  factory CalendarDayView.inRow({
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
  factory CalendarDayView.eventOnly({
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
