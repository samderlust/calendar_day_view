// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DayViewOptions {
  /// The width of the column that contain list of time points
  final double timeTitleColumnWidth;

  /// To show a line that indicate current hour and minute;
  final bool showCurrentTimeLine;

  /// Color of the current time line
  final Color? currentTimeLineColor;

  /// height in pixel per minute
  final double heightPerMin;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay endOfDay;

  /// time gap/duration of a row.
  final int timeGap;

  /// color of time point label
  final Color? timeTextColor;

  /// style of time point label
  final TextStyle? timeTextStyle;

  /// time slot divider color
  final Color? dividerColor;

  /// show time in 12 hour format
  final bool time12;

  DayViewOptions({
    this.timeTitleColumnWidth = 70.0,
    this.startOfDay = const TimeOfDay(hour: 7, minute: 00),
    this.endOfDay = const TimeOfDay(hour: 17, minute: 00),
    this.heightPerMin = 1.0,
    this.timeGap = 60,
    this.showCurrentTimeLine = false,
    this.time12 = false,
    this.currentTimeLineColor,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
  });
}

class CategoryDayViewOptions extends DayViewOptions {
  /// dividers that run vertically in the day view
  final VerticalDivider? verticalDivider;

  /// dividers that run horizontally in the day view
  final Divider? horizontalDivider;

  /// header row decoration
  final BoxDecoration? headerDecoration;

  /// The widget that will be place at top left corner tile of this day view
  final Widget? logo;

  /// number of columns per page, only affect when [allowHorizontalScroll] = true
  final double columnsPerPage;

  /// if true the day view can be scrolled horizontally to show more categories
  final bool allowHorizontalScroll;
  final Color? evenRowColor;
  final Color? oddRowColor;

  CategoryDayViewOptions({
    this.evenRowColor,
    this.oddRowColor,
    this.verticalDivider,
    this.horizontalDivider,
    this.headerDecoration,
    this.logo,
    this.columnsPerPage = 3,
    this.allowHorizontalScroll = false,
    super.timeTitleColumnWidth,
    super.startOfDay,
    super.endOfDay,
    super.heightPerMin,
    super.timeGap,
    super.showCurrentTimeLine,
    super.time12,
    super.currentTimeLineColor,
    super.timeTextColor,
    super.timeTextStyle,
    super.dividerColor,
  });
}
