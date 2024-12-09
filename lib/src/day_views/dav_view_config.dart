import 'package:calendar_day_view/src/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

import '../utils/date_time_utils.dart';

abstract class DavViewConfig {
  /// width of the first column where times are displayed
  final double timeColumnWidth;

  /// the date that this dayView is presenting
  final DateTime currentDate;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay endOfDay;

  /// time label text style
  final TextStyle? timeTextStyle;

  /// time gap/duration of a row.
  ///
  /// This will determine the minimum height of a row
  /// row height is calculated by `rowHeight = heightPerMin * timeGap`
  final int timeGap;

  /// show time in 12 hour format
  final bool time12;

  /// height in pixel per minute
  final double heightPerMin;

  /// To show a line that indicate current hour and minute;
  final bool showCurrentTimeLine;

  /// time slot divider color
  final Color? dividerColor;

  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const DavViewConfig({
    this.timeColumnWidth = 70,
    this.startOfDay = const TimeOfDay(hour: 7, minute: 0),
    this.endOfDay = const TimeOfDay(hour: 18, minute: 59),
    required this.currentDate,
    this.timeTextStyle,
    this.timeGap = 60,
    this.time12 = true,
    this.heightPerMin = 1,
    this.showCurrentTimeLine = true,
    this.primary,
    this.physics,
    this.controller,
    this.dividerColor,
  });

  double get rowHeight => heightPerMin * timeGap;
  List<DateTime> get timeList => getTimeList(
        currentDate.copyTimeAndMinClean(startOfDay),
        currentDate.copyTimeAndMinClean(endOfDay),
        timeGap,
      );

  DateTime get timeStart => currentDate.copyTimeAndMinClean(startOfDay);
  DateTime get timeEnd => currentDate.copyTimeAndMinClean(endOfDay);
}

/// Configuration for [CategoryDavView] and [CategoryOverflowCalendarDayView]
class CategoryDavViewConfig extends DavViewConfig {
  /// build category header
  // final CategoryDayViewHeaderTileBuilder? headerTileBuilder;

  /// header row decoration
  final BoxDecoration? headerDecoration;

  /// The widget that will be place at top left corner tile of this day view
  final Widget? logo;

  /// if true the day view can be scrolled horizontally to show more categories
  final bool allowHorizontalScroll;

  /// number of columns per page, only affect when [allowHorizontalScroll] = true
  final double columnsPerPage;

  /// background color of the even-indexed row
  final Color? evenRowColor;

  /// background color of the odd-indexed row
  final Color? oddRowColor;

  /// dividers that run vertically in the day view
  final VerticalDivider? verticalDivider;

  /// dividers that run horizontally in the day view
  final Divider? horizontalDivider;

  /// time label text style
  final TextStyle? timeTextStyle;

  const CategoryDavViewConfig({
    this.headerDecoration,
    this.logo,
    this.evenRowColor,
    this.oddRowColor,
    this.verticalDivider,
    this.horizontalDivider,
    this.timeTextStyle,
    this.allowHorizontalScroll = false,
    this.columnsPerPage = 3,
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.timeColumnWidth,
  });
}

class OverFlowDayViewConfig extends DavViewConfig {
  /// color of time point label
  final Color? timeTextColor;

  /// style of time point label
  final TextStyle? timeTextStyle;

  /// allow render an events row as a ListView
  final bool renderRowAsListView;

  /// allow render button indicate there are more events on the row
  /// also tap to scroll the list to the right
  final bool showMoreOnRowButton;

  /// customized button that indicate there are more events on the row
  final Widget? moreOnRowButton;

  /// if true, the bottom events' end time will be cropped by the end time of day view
  /// if false, events that have end time after day view end time will have the show the length that pass through day view end time
  final bool cropBottomEvents;

  /// Color of the current time line
  final Color? currentTimeLineColor;

  const OverFlowDayViewConfig({
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.timeColumnWidth,
    super.primary,
    super.physics,
    super.controller,
    this.timeTextColor,
    this.timeTextStyle,
    super.dividerColor,
    this.renderRowAsListView = false,
    this.showMoreOnRowButton = false,
    this.cropBottomEvents = false,
    this.moreOnRowButton,
    this.currentTimeLineColor,
  });
}

class EventDayViewConfig extends DavViewConfig {
  /// padding for event row
  final EdgeInsetsGeometry? rowPadding;

  ///padding for time slot
  final EdgeInsetsGeometry? timeSlotPadding;

  /// show event by hour only
  final bool showHourly;

  const EventDayViewConfig({
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.timeColumnWidth,
    super.primary,
    super.physics,
    super.dividerColor,
    super.controller,
    this.rowPadding,
    this.timeSlotPadding,
    this.showHourly = false,
  });
}

class InRowDayViewConfig extends EventDayViewConfig {
  /// if true, only display row with events. Default to false
  final bool showWithEventOnly;

  final Color? currentTimeLineColor;
  InRowDayViewConfig({
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.timeColumnWidth,
    super.primary,
    super.physics,
    super.dividerColor,
    super.controller,
    super.rowPadding,
    super.timeSlotPadding,
    super.showHourly,
    this.showWithEventOnly = false,
    this.currentTimeLineColor,
  });
}
