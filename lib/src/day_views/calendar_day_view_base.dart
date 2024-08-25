import 'package:calendar_day_view/src/day_views/category/category_overflow_calendar_day_view.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';

abstract class CalendarDayView<T extends Object> extends Widget {
  /// Create [OverFlowCalendarDayView]
  ///
  /// where event widget can be display overflowed to other time row

  factory CalendarDayView.overflow({
    DayViewOptions? options,
    bool? renderRowAsListView,
    bool? showMoreOnRowButton,
    required DateTime currentDate,
    required List<DayEvent<T>> events,
    DayViewItemBuilder<T>? overflowItemBuilder,
    Widget? moreOnRowButton,
    OnTimeTap? onTimeTap,
    bool? primary,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? cropBottomEvents,
  }) =>
      OverFlowCalendarDayView<T>(
        options: options ?? DayViewOptions(),
        currentDate: currentDate,
        renderRowAsListView: renderRowAsListView ?? false,
        showMoreOnRowButton: showMoreOnRowButton ?? false,
        events: events,
        overflowItemBuilder: overflowItemBuilder,
        moreOnRowButton: moreOnRowButton,
        onTimeTap: onTimeTap,
        primary: primary,
        physics: physics,
        controller: controller,
        cropBottomEvents: cropBottomEvents ?? false,
      );

  /// Create [CategoryCalendarDayView]
  ///
  /// where day view is divided into multiple category with fixed time slot.
  /// event will be showed within the correspond event tile only.
  factory CalendarDayView.category({
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    required DateTime currentDate,
    CategoryDayViewOptions? options,
    CategoryDayViewTileTap? onTileTap,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
  }) =>
      CategoryCalendarDayView(
        currentDate: currentDate,
        eventBuilder: eventBuilder,
        events: events,
        categories: categories,
        onTileTap: onTileTap,
        controlBarBuilder: controlBarBuilder,
        options: options ?? CategoryDayViewOptions(),
      );

  /// Create [CategoryOverflowCalendarDayView]
  ///
  /// where day view is divided into multiple category with fixed time slot.
  /// event can be display overflowed into different time slot but within the same category column
  factory CalendarDayView.categoryOverflow({
    required List<CategorizedDayEvent<T>> events,
    required List<EventCategory> categories,
    required DateTime currentDate,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
    CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder,
    CategoryDayViewOptions? options,
    CategoryDayViewTileTap? onTileTap,
  }) =>
      CategoryOverflowCalendarDayView(
        events: events,
        categories: categories,
        controlBarBuilder: controlBarBuilder,
        backgroundTimeTileBuilder: backgroundTimeTileBuilder,
        eventBuilder: eventBuilder,
        onTileTap: onTileTap,
        currentDate: currentDate,
        options: options ?? CategoryDayViewOptions(),
      );

  /// Create [InRowCalendarDayView]
  ///
  /// Show all events that are happened in the same time gap window in a single row
  factory CalendarDayView.inRow({
    required List<DayEvent<T>> events,
    required DateTime currentDate,
    TimeOfDay? startOfDay,
    TimeOfDay? endOfDay,
    Color? currentTimeLineColor,
    bool? showCurrentTimeLine,
    double? heightPerMin,
    bool? showWithEventOnly,
    int? timeGap,
    Color? timeTextColor,
    TextStyle? timeTextStyle,
    Color? dividerColor,
    DayViewItemBuilder<T>? itemBuilder,
    DayViewTimeRowBuilder<T>? timeRowBuilder,
    OnTimeTap? onTap,
    bool? primary,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? time12,
  }) =>
      InRowCalendarDayView(
        time12: time12 ?? false,
        currentTimeLineColor: currentTimeLineColor,
        startOfDay: startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        showCurrentTimeLine: showCurrentTimeLine ?? false,
        heightPerMin: heightPerMin ?? 1.0,
        showWithEventOnly: showWithEventOnly ?? false,
        timeGap: timeGap ?? 60,
        currentDate: currentDate,
        events: events,
        timeTextColor: timeTextColor,
        timeTextStyle: timeTextStyle,
        dividerColor: dividerColor,
        itemBuilder: itemBuilder,
        timeRowBuilder: timeRowBuilder,
        onTap: onTap,
        primary: primary,
        physics: physics,
        controller: controller,
      );

  /// Create [EventCalendarDayView]
  ///
  /// this day view doesn't display with a fixed time gap
  /// it listed and sorted by the time that the events start
  factory CalendarDayView.eventOnly({
    required List<DayEvent<T>> events,
    required EventDayViewItemBuilder<T> eventDayViewItemBuilder,
    Color? timeTextColor,
    TextStyle? timeTextStyle,
    IndexedWidgetBuilder? itemSeparatorBuilder,
    Color? dividerColor,
    EdgeInsetsGeometry? rowPadding,
    EdgeInsetsGeometry? timeSlotPadding,
    bool? primary,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? time12,
  }) =>
      EventCalendarDayView(
        time12: time12 ?? false,
        events: events,
        eventDayViewItemBuilder: eventDayViewItemBuilder,
        timeTextColor: timeTextColor,
        timeTextStyle: timeTextStyle,
        itemSeparatorBuilder: itemSeparatorBuilder,
        dividerColor: dividerColor,
        rowPadding: rowPadding,
        timeSlotPadding: timeSlotPadding,
        primary: primary,
        physics: physics,
        controller: controller,
      );
}
