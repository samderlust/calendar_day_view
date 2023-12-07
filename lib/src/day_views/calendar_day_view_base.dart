import 'package:calendar_day_view/src/day_views/category/category_overflow_calendar_day_view.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';

abstract class CalendarDayView<T extends Object> extends Widget {
  /// Create [OverFlowCalendarDayView]
  ///
  /// where event widget can be display overflowed to other time row

  factory CalendarDayView.overflow({
    double? timeTitleColumnWidth,
    bool? showCurrentTimeLine,
    Color? currentTimeLineColor,
    double? heightPerMin,
    TimeOfDay? startOfDay,
    TimeOfDay? endOfDay,
    int? timeGap,
    bool? renderRowAsListView,
    bool? showMoreOnRowButton,
    required List<DayEvent<T>> events,
    required DateTime currentDate,
    Color? timeTextColor,
    TextStyle? timeTextStyle,
    Color? dividerColor,
    DayViewItemBuilder<T>? overflowItemBuilder,
    Widget? moreOnRowButton,
    OnTimeTap? onTimeTap,
    bool? primary,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? cropBottomEvents,
  }) =>
      OverFlowCalendarDayView<T>(
        timeTitleColumnWidth: timeTitleColumnWidth ?? 50,
        showCurrentTimeLine: showCurrentTimeLine ?? false,
        currentTimeLineColor: currentTimeLineColor,
        heightPerMin: heightPerMin ?? 1.0,
        startOfDay: startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        timeGap: timeGap ?? 60,
        renderRowAsListView: renderRowAsListView ?? false,
        showMoreOnRowButton: showMoreOnRowButton ?? false,
        events: events,
        currentDate: currentDate,
        timeTextColor: timeTextColor,
        timeTextStyle: timeTextStyle,
        dividerColor: dividerColor,
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
    required DateTime currentDate,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    double? timeColumnWidth,
    TimeOfDay? startOfDay,
    TimeOfDay? endOfDay,
    int? timeGap,
    double? heightPerMin,
    bool? allowHorizontalScroll,
    double? columnsPerPage,
    Color? evenRowColor,
    Color? oddRowColor,
    VerticalDivider? verticalDivider,
    Divider? horizontalDivider,
    TextStyle? timeTextStyle,
    CategoryDayViewTileTap? onTileTap,
    BoxDecoration? headerDecoration,
    Widget? logo,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
  }) =>
      CategoryCalendarDayView(
        events: events,
        currentDate: currentDate,
        categories: categories,
        timeColumnWidth: timeColumnWidth ?? 50,
        heightPerMin: heightPerMin ?? 1.0,
        startOfDay: startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        eventBuilder: eventBuilder,
        timeGap: timeGap ?? 60,
        allowHorizontalScroll: allowHorizontalScroll ?? false,
        columnsPerPage: columnsPerPage ?? 3,
        evenRowColor: evenRowColor,
        oddRowColor: oddRowColor,
        verticalDivider: verticalDivider,
        horizontalDivider: horizontalDivider,
        timeTextStyle: timeTextStyle,
        onTileTap: onTileTap,
        headerDecoration: headerDecoration,
        logo: logo,
        controlBarBuilder: controlBarBuilder,
      );

  /// Create [CategoryOverflowCalendarDayView]
  ///
  /// where day view is divided into multiple category with fixed time slot.
  /// event can be display overflowed into different time slot but within the same category column
  factory CalendarDayView.categoryOverflow({
    required List<CategorizedDayEvent<T>> events,
    required DateTime currentDate,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    double? timeColumnWidth,
    TimeOfDay? startOfDay,
    TimeOfDay? endOfDay,
    int? timeGap,
    double? heightPerMin,
    bool? allowHorizontalScroll,
    double? columnsPerPage,
    Color? evenRowColor,
    Color? oddRowColor,
    VerticalDivider? verticalDivider,
    Divider? horizontalDivider,
    TextStyle? timeTextStyle,
    CategoryDayViewTileTap? onTileTap,
    BoxDecoration? headerDecoration,
    Widget? logo,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
    CategoryBackgroundTimeRowBuilder? timeRowBuilder,
  }) =>
      CategoryOverflowCalendarDayView(
        events: events,
        currentDate: currentDate,
        categories: categories,
        timeColumnWidth: timeColumnWidth ?? 50,
        heightPerMin: heightPerMin ?? 1.0,
        startOfDay: startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        eventBuilder: eventBuilder,
        timeGap: timeGap ?? 60,
        allowHorizontalScroll: allowHorizontalScroll ?? false,
        columnsPerPage: columnsPerPage ?? 3,
        evenRowColor: evenRowColor,
        oddRowColor: oddRowColor,
        verticalDivider: verticalDivider,
        horizontalDivider: horizontalDivider,
        timeTextStyle: timeTextStyle,
        onTileTap: onTileTap,
        headerDecoration: headerDecoration,
        logo: logo,
        controlBarBuilder: controlBarBuilder,
        timeRowBuilder: timeRowBuilder,
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
  }) =>
      InRowCalendarDayView(
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
  }) =>
      EventCalendarDayView(
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
