import 'package:flutter/material.dart';

import '../extensions/date_time_extension.dart';
import '../models/typedef.dart';
import '../utils/date_time_utils.dart';
import 'day_view_decoration.dart';

/// Base configuration shared by all calendar day views.
///
/// Subclasses add view-specific options: [CategoryDavViewConfig],
/// [OverFlowDayViewConfig], [EventDayViewConfig], [InRowDayViewConfig],
/// [MultiColumnDayViewConfig].
///
/// Visual customization (time label, divider, row background, current time
/// line, header, footer, etc.) is grouped in [decoration] so it can be
/// reused across view types.
abstract class DavViewConfig {
  /// The date that this day view is presenting.
  ///
  /// Only the date portion is used — [startOfDay] and [endOfDay] are
  /// combined with this date to compute [timeStart] and [timeEnd].
  final DateTime currentDate;

  /// The first time-of-day shown in the view. Defaults to 07:00.
  final TimeOfDay startOfDay;

  /// The last time-of-day shown in the view. Defaults to 18:59.
  final TimeOfDay endOfDay;

  /// Duration of each time row in minutes.
  ///
  /// The row height is `heightPerMin * timeGap`.
  final int timeGap;

  /// Whether time labels are formatted in 12-hour mode. Defaults to true.
  final bool time12;

  /// Vertical pixels rendered per minute.
  ///
  /// Together with [timeGap] this determines row height.
  final double heightPerMin;

  /// Whether to render a horizontal line at the current time.
  final bool showCurrentTimeLine;

  /// Forwarded to the view's internal scrollable. See
  /// [ScrollView.primary].
  final bool? primary;

  /// Forwarded to the view's internal scrollable. See
  /// [ScrollView.physics].
  final ScrollPhysics? physics;

  /// Optional scroll controller for the view's internal scrollable.
  ///
  /// When null and [scrollToCurrentTime] is true, an internal controller is
  /// created automatically so the view can auto-scroll on first render.
  final ScrollController? controller;

  /// Whether to automatically scroll to the current time on initial render.
  final bool scrollToCurrentTime;

  /// Whether events extending past [endOfDay] should be cropped at that
  /// boundary, or allowed to render their full length past it.
  final bool cropBottomEvents;

  /// All visual styling and builder callbacks for the view.
  ///
  /// A single [DayViewDecoration] can be shared across multiple views to
  /// enforce consistent branding.
  final DayViewDecoration decoration;

  /// Creates a base day view config.
  const DavViewConfig({
    this.startOfDay = const TimeOfDay(hour: 7, minute: 0),
    this.endOfDay = const TimeOfDay(hour: 18, minute: 59),
    required this.currentDate,
    this.timeGap = 60,
    this.time12 = true,
    this.heightPerMin = 1,
    this.showCurrentTimeLine = true,
    this.primary,
    this.physics,
    this.controller,
    this.scrollToCurrentTime = false,
    this.cropBottomEvents = false,
    this.decoration = const DayViewDecoration(),
  });

  /// The computed height of a single time row
  /// (`heightPerMin * timeGap`).
  double get rowHeight => heightPerMin * timeGap;

  /// The ordered list of row start times between [timeStart] and [timeEnd],
  /// spaced [timeGap] minutes apart.
  List<DateTime> get timeList => getTimeList(
        currentDate.copyTimeAndMinClean(startOfDay),
        currentDate.copyTimeAndMinClean(endOfDay),
        timeGap,
      );

  /// Absolute start [DateTime] — [currentDate] combined with [startOfDay].
  DateTime get timeStart => currentDate.copyTimeAndMinClean(startOfDay);

  /// Absolute end [DateTime] — [currentDate] combined with [endOfDay].
  DateTime get timeEnd => currentDate.copyTimeAndMinClean(endOfDay);
}

/// Configuration for [CategoryDayView] and [CategoryOverflowDayView].
///
/// Adds category-specific options such as header decoration, logo, column
/// layout, and alternating row colors.
final class CategoryDavViewConfig extends DavViewConfig {
  /// Decoration applied to the header row (the row showing category names).
  final BoxDecoration? headerDecoration;

  /// Widget placed in the top-left corner (above the time column).
  final Widget? logo;

  /// If true, the view can be scrolled horizontally to reveal more
  /// categories; only [columnsPerPage] are visible at a time.
  final bool allowHorizontalScroll;

  /// Number of category columns visible per page.
  ///
  /// Only has effect when [allowHorizontalScroll] is true.
  final int columnsPerPage;

  /// Background color applied to even-indexed time rows (0, 2, 4, ...).
  final Color? evenRowColor;

  /// Background color applied to odd-indexed time rows (1, 3, 5, ...).
  final Color? oddRowColor;

  /// Custom vertical divider between category columns.
  final VerticalDivider? verticalDivider;

  /// Custom horizontal divider between time rows.
  final Divider? horizontalDivider;

  /// Whether the header row stays pinned to the top while scrolling.
  ///
  /// Defaults to true.
  final bool freezeCategoryTitleRow;

  /// Text style applied to the category name in the header row.
  final TextStyle? categoryTitleTextStyle;

  /// When true, all events that fall in the same category cell are rendered
  /// horizontally side-by-side. When false (default), only the first event
  /// is shown.
  final bool showAllEventsInCell;

  /// Creates a [CategoryDavViewConfig].
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
    super.decoration,
    this.categoryTitleTextStyle,
  });
}

/// Configuration for [OverFlowCalendarDayView].
///
/// The overflow view groups overlapping events into rows. Row contents
/// can be rendered as a horizontal [ListView] (via [renderRowAsListView])
/// or as fixed-width columns.
final class OverFlowDayViewConfig extends DavViewConfig {
  /// Render each overflow row as a horizontal [ListView] rather than as a
  /// set of fixed-width columns.
  final bool renderRowAsListView;

  /// Show a button at the right edge of rows that have more events than
  /// fit on screen. Tapping the button scrolls the list to the right.
  ///
  /// Only relevant when [renderRowAsListView] is true.
  final bool showMoreOnRowButton;

  /// Custom widget for the "more" button. If null, a default icon is used.
  final Widget? moreOnRowButton;

  /// Creates an [OverFlowDayViewConfig].
  const OverFlowDayViewConfig({
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.primary,
    super.physics,
    super.controller,
    super.scrollToCurrentTime,
    super.cropBottomEvents,
    super.decoration,
    this.renderRowAsListView = false,
    this.showMoreOnRowButton = false,
    this.moreOnRowButton,
  });
}

/// Configuration for [EventCalendarDayView].
///
/// The event-only view lists events chronologically without a fixed time
/// grid. Only time rows that have at least one event are displayed.
final class EventDayViewConfig extends DavViewConfig {
  /// Padding around each event row.
  final EdgeInsetsGeometry? rowPadding;

  /// Padding around each time slot label.
  final EdgeInsetsGeometry? timeSlotPadding;

  /// When true, events are grouped by hour only (minute component ignored).
  final bool showHourly;

  /// Creates an [EventDayViewConfig].
  const EventDayViewConfig({
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.primary,
    super.physics,
    super.scrollToCurrentTime,
    super.controller,
    super.decoration,
    this.rowPadding,
    this.timeSlotPadding,
    this.showHourly = false,
  });
}

/// Configuration for [InRowCalendarDayView].
///
/// Extends [EventDayViewConfig] with an option to hide time rows that
/// contain no events.
final class InRowDayViewConfig extends EventDayViewConfig {
  /// When true, rows that contain no events are hidden.
  final bool showWithEventOnly;

  /// Creates an [InRowDayViewConfig].
  InRowDayViewConfig({
    required super.currentDate,
    super.scrollToCurrentTime,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.primary,
    super.physics,
    super.controller,
    super.rowPadding,
    super.timeSlotPadding,
    super.showHourly,
    super.decoration,
    this.showWithEventOnly = false,
  });
}

/// Configuration for [MultiColumnCalendarDayView].
///
/// The `<T>` type parameter matches the event's [DayEvent] value type and
/// is required because [overlapStrategy] returns typed [ColumnEvent]s.
final class MultiColumnDayViewConfig<T extends Object> extends DavViewConfig {
  /// Custom overlap layout strategy.
  ///
  /// When null (default), the built-in greedy interval graph coloring
  /// algorithm is used. Provide a custom [OverlapStrategy] to implement an
  /// alternative layout — for example, stacking all overlapping events
  /// into a single column, or using different tie-breaking rules.
  final OverlapStrategy<T>? overlapStrategy;

  /// Creates a [MultiColumnDayViewConfig].
  const MultiColumnDayViewConfig({
    required super.currentDate,
    super.startOfDay,
    super.endOfDay,
    super.timeGap,
    super.time12,
    super.heightPerMin,
    super.showCurrentTimeLine,
    super.primary,
    super.physics,
    super.controller,
    super.scrollToCurrentTime,
    super.cropBottomEvents,
    super.decoration,
    this.overlapStrategy,
  });
}
