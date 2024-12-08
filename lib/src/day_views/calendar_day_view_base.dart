import 'package:calendar_day_view/src/day_views/category/category_overflow_calendar_day_view.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';

class DayViewOptions {
  final TimeOfDay startOfDay;
  final TimeOfDay endOfDay;
  final double heightPerMin;
  final int timeGap;
  final Color? timeTextColor;
  final TextStyle? timeTextStyle;
  final Color? dividerColor;
  final bool time12;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final double timeColumnWidth;

  const DayViewOptions({
    this.startOfDay = const TimeOfDay(hour: 7, minute: 00),
    this.endOfDay = const TimeOfDay(hour: 17, minute: 00),
    this.heightPerMin = 1.0,
    this.timeGap = 60,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
    this.time12 = false,
    this.physics,
    this.controller,
    this.primary,
    this.timeColumnWidth = 50,
  });
}

abstract class CalendarDayView<T extends Object> extends Widget {
  factory CalendarDayView.overflow({
    required List<DayEvent<T>> events,
    required DateTime currentDate,
    DayViewOptions? options,
    bool? showCurrentTimeLine,
    Color? currentTimeLineColor,
    bool? renderRowAsListView,
    bool? showMoreOnRowButton,
    DayViewItemBuilder<T>? overflowItemBuilder,
    Widget? moreOnRowButton,
    OnTimeTap? onTimeTap,
    bool? cropBottomEvents,
  }) =>
      OverFlowCalendarDayView<T>(
        timeTitleColumnWidth: options?.timeColumnWidth ?? 50,
        showCurrentTimeLine: showCurrentTimeLine ?? false,
        currentTimeLineColor: currentTimeLineColor,
        heightPerMin: options?.heightPerMin ?? 1.0,
        startOfDay: options?.startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: options?.endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        timeGap: options?.timeGap ?? 60,
        renderRowAsListView: renderRowAsListView ?? false,
        showMoreOnRowButton: showMoreOnRowButton ?? false,
        events: events,
        currentDate: currentDate,
        timeTextColor: options?.timeTextColor,
        timeTextStyle: options?.timeTextStyle,
        dividerColor: options?.dividerColor,
        overflowItemBuilder: overflowItemBuilder,
        moreOnRowButton: moreOnRowButton,
        onTimeTap: onTimeTap,
        primary: options?.primary,
        physics: options?.physics,
        controller: options?.controller,
        cropBottomEvents: cropBottomEvents ?? false,
        time12: options?.time12 ?? false,
      );

  factory CalendarDayView.category({
    required List<CategorizedDayEvent<T>> events,
    required DateTime currentDate,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    DayViewOptions? options,
    bool? allowHorizontalScroll,
    double? columnsPerPage,
    Color? evenRowColor,
    Color? oddRowColor,
    VerticalDivider? verticalDivider,
    Divider? horizontalDivider,
    CategoryDayViewTileTap? onTileTap,
    BoxDecoration? headerDecoration,
    Widget? logo,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
  }) =>
      CategoryCalendarDayView(
        time12: options?.time12 ?? false,
        events: events,
        currentDate: currentDate,
        categories: categories,
        timeColumnWidth: options?.timeColumnWidth ?? 50,
        heightPerMin: options?.heightPerMin ?? 1.0,
        startOfDay: options?.startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: options?.endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        eventBuilder: eventBuilder,
        timeGap: options?.timeGap ?? 60,
        allowHorizontalScroll: allowHorizontalScroll ?? false,
        columnsPerPage: columnsPerPage ?? 3,
        evenRowColor: evenRowColor,
        oddRowColor: oddRowColor,
        verticalDivider: verticalDivider,
        horizontalDivider: horizontalDivider,
        timeTextStyle: options?.timeTextStyle,
        onTileTap: onTileTap,
        headerDecoration: headerDecoration,
        logo: logo,
        controlBarBuilder: controlBarBuilder,
      );

  factory CalendarDayView.categoryOverflow({
    required List<CategorizedDayEvent<T>> events,
    required DateTime currentDate,
    required List<EventCategory> categories,
    required CategoryDayViewEventBuilder<T> eventBuilder,
    DayViewOptions? options,
    bool? allowHorizontalScroll,
    double? columnsPerPage,
    Color? evenRowColor,
    Color? oddRowColor,
    VerticalDivider? verticalDivider,
    Divider? horizontalDivider,
    CategoryDayViewTileTap? onTileTap,
    BoxDecoration? headerDecoration,
    Widget? logo,
    CategoryDayViewControlBarBuilder? controlBarBuilder,
    CategoryBackgroundTimeTileBuilder? backgroundTimeTileBuilder,
  }) =>
      CategoryOverflowCalendarDayView(
        time12: options?.time12 ?? false,
        events: events,
        currentDate: currentDate,
        categories: categories,
        timeColumnWidth: options?.timeColumnWidth ?? 50,
        heightPerMin: options?.heightPerMin ?? 1.0,
        startOfDay: options?.startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: options?.endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        eventBuilder: eventBuilder,
        timeGap: options?.timeGap ?? 60,
        allowHorizontalScroll: allowHorizontalScroll ?? false,
        columnsPerPage: columnsPerPage ?? 3,
        evenRowColor: evenRowColor,
        oddRowColor: oddRowColor,
        verticalDivider: verticalDivider,
        horizontalDivider: horizontalDivider,
        timeTextStyle: options?.timeTextStyle,
        onTileTap: onTileTap,
        headerDecoration: headerDecoration,
        logo: logo,
        controlBarBuilder: controlBarBuilder,
        backgroundTimeTileBuilder: backgroundTimeTileBuilder,
      );

  factory CalendarDayView.inRow({
    required List<DayEvent<T>> events,
    required DateTime currentDate,
    DayViewOptions? options,
    Color? currentTimeLineColor,
    bool? showCurrentTimeLine,
    bool? showWithEventOnly,
    DayViewItemBuilder<T>? itemBuilder,
    DayViewTimeRowBuilder<T>? timeRowBuilder,
    OnTimeTap? onTap,
  }) =>
      InRowCalendarDayView(
        time12: options?.time12 ?? false,
        currentTimeLineColor: currentTimeLineColor,
        startOfDay: options?.startOfDay ?? const TimeOfDay(hour: 7, minute: 00),
        endOfDay: options?.endOfDay ?? const TimeOfDay(hour: 17, minute: 00),
        showCurrentTimeLine: showCurrentTimeLine ?? false,
        heightPerMin: options?.heightPerMin ?? 1.0,
        showWithEventOnly: showWithEventOnly ?? false,
        timeGap: options?.timeGap ?? 60,
        currentDate: currentDate,
        events: events,
        timeTextColor: options?.timeTextColor,
        timeTextStyle: options?.timeTextStyle,
        dividerColor: options?.dividerColor,
        itemBuilder: itemBuilder,
        timeRowBuilder: timeRowBuilder,
        onTap: onTap,
        primary: options?.primary,
        physics: options?.physics,
        controller: options?.controller,
      );

  factory CalendarDayView.eventOnly({
    required List<DayEvent<T>> events,
    required EventDayViewItemBuilder<T> eventDayViewItemBuilder,
    DayViewOptions? options,
    IndexedWidgetBuilder? itemSeparatorBuilder,
    EdgeInsetsGeometry? rowPadding,
    EdgeInsetsGeometry? timeSlotPadding,
    bool? showHourly,
  }) =>
      EventCalendarDayView(
        time12: options?.time12 ?? false,
        events: events,
        eventDayViewItemBuilder: eventDayViewItemBuilder,
        timeTextColor: options?.timeTextColor,
        timeTextStyle: options?.timeTextStyle,
        itemSeparatorBuilder: itemSeparatorBuilder,
        dividerColor: options?.dividerColor,
        rowPadding: rowPadding,
        timeSlotPadding: timeSlotPadding,
        primary: options?.primary,
        physics: options?.physics,
        controller: options?.controller,
        showHourly: showHourly ?? false,
      );
}
