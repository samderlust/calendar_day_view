import 'package:flutter/material.dart';

import '../extensions/date_time_extension.dart';
import '../models/typedef.dart';
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

  /// Color of the current time line
  final Color? currentTimeLineColor;

  /// time slot divider color
  final Color? dividerColor;

  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  /// allow custom time label
  /// if not provided, the time will be display as default time format
  /// either 12 hour or 24 hour format based on [time12]
  final TimeLabelBuilder? timeLabelBuilder;

  /// allow custom current time line widget
  final CurrentTimeLineBuilder? currentTimeLineBuilder;

  /// allow custom background for each time row
  ///
  /// Return null to use the default (transparent) background for a row.
  /// Useful for shading lunch break, working hours, unavailable blocks, etc.
  final TimeRowBackgroundBuilder? timeRowBackgroundBuilder;

  /// allow custom divider between time rows
  ///
  /// Return null to skip the divider for a specific row.
  /// If this builder itself is null, the default divider is used.
  final DividerBuilder? dividerBuilder;

  /// if true, auto scroll to current time on initial render
  final bool scrollToCurrentTime;

  /// if true, the bottom events' end time will be cropped by the end time of day view
  /// if false, events that have end time after day view end time will show the length that passes through day view end time
  final bool cropBottomEvents;

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
    this.currentTimeLineColor,
    this.primary,
    this.physics,
    this.controller,
    this.dividerColor,
    this.timeLabelBuilder,
    this.currentTimeLineBuilder,
    this.timeRowBackgroundBuilder,
    this.dividerBuilder,
    this.scrollToCurrentTime = false,
    this.cropBottomEvents = false,
  });

  double get rowHeight => heightPerMin * timeGap;

  /// number of time rows to display
  List<DateTime> get timeList => getTimeList(
        currentDate.copyTimeAndMinClean(startOfDay),
        currentDate.copyTimeAndMinClean(endOfDay),
        timeGap,
      );

  DateTime get timeStart => currentDate.copyTimeAndMinClean(startOfDay);
  DateTime get timeEnd => currentDate.copyTimeAndMinClean(endOfDay);
}

/// Configuration for [CategoryDayView] and [CategoryOverflowDayView]
final class CategoryDavViewConfig extends DavViewConfig {
  /// header row decoration
  final BoxDecoration? headerDecoration;

  /// The widget that will be place at top left corner tile of this day view
  final Widget? logo;

  /// if true the day view can be scrolled horizontally to show more categories
  final bool allowHorizontalScroll;

  /// number of columns per page, only affect when [allowHorizontalScroll] = true
  final int columnsPerPage;

  /// background color of the even-indexed row
  final Color? evenRowColor;

  /// background color of the odd-indexed row
  final Color? oddRowColor;

  /// dividers that run vertically in the day view
  final VerticalDivider? verticalDivider;

  /// dividers that run horizontally in the day view
  final Divider? horizontalDivider;

  /// if true, the category view will be frozen when scrolling
  ///
  /// default to true
  final bool freezeCategoryTitleRow;

  final TextStyle? categoryTitleTextStyle;

  /// if true, show all events in a cell horizontally
  /// if false, only show the first event in a cell
  final bool showAllEventsInCell;

  const CategoryDavViewConfig({
    this.headerDecoration,
    this.logo,
    this.evenRowColor,
    this.oddRowColor,
    this.verticalDivider,
    this.horizontalDivider,
    this.allowHorizontalScroll = false,
    this.columnsPerPage = 3,
    this.freezeCategoryTitleRow = true,
    this.showAllEventsInCell = false,
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.timeColumnWidth,
    super.timeLabelBuilder,
    super.timeRowBackgroundBuilder,
    super.dividerBuilder,
    this.categoryTitleTextStyle,
  });
}

final class OverFlowDayViewConfig extends DavViewConfig {
  /// color of time point label
  final Color? timeTextColor;

  /// allow render an events row as a ListView
  final bool renderRowAsListView;

  /// allow render button indicate there are more events on the row
  /// also tap to scroll the list to the right
  final bool showMoreOnRowButton;

  /// customized button that indicate there are more events on the row
  final Widget? moreOnRowButton;

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
    super.dividerColor,
    super.timeTextStyle,
    super.timeLabelBuilder,
    super.currentTimeLineBuilder,
    super.timeRowBackgroundBuilder,
    super.dividerBuilder,
    super.scrollToCurrentTime,
    super.currentTimeLineColor,
    super.cropBottomEvents,
    this.renderRowAsListView = false,
    this.showMoreOnRowButton = false,
    this.moreOnRowButton,
  });
}

final class EventDayViewConfig extends DavViewConfig {
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
    super.currentTimeLineColor,
    super.timeColumnWidth,
    super.primary,
    super.physics,
    super.dividerColor,
    super.timeLabelBuilder,
    super.currentTimeLineBuilder,
    super.timeRowBackgroundBuilder,
    super.dividerBuilder,
    super.scrollToCurrentTime,
    super.controller,
    this.rowPadding,
    this.timeSlotPadding,
    this.showHourly = false,
  });
}

final class InRowDayViewConfig extends EventDayViewConfig {
  /// if true, only display row with events. Default to false
  final bool showWithEventOnly;

  InRowDayViewConfig({
    required super.currentDate,
    super.timeLabelBuilder,
    super.currentTimeLineBuilder,
    super.timeRowBackgroundBuilder,
    super.dividerBuilder,
    super.scrollToCurrentTime,
    super.currentTimeLineColor,
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
  });
}

final class MultiColumnDayViewConfig extends DavViewConfig {
  const MultiColumnDayViewConfig({
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
    super.dividerColor,
    super.timeTextStyle,
    super.timeLabelBuilder,
    super.currentTimeLineBuilder,
    super.timeRowBackgroundBuilder,
    super.dividerBuilder,
    super.scrollToCurrentTime,
    super.currentTimeLineColor,
    super.cropBottomEvents,
  });
}
