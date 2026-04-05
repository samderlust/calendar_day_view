import 'package:flutter/material.dart';

import '../models/typedef.dart';

/// Visual decoration for a day view.
///
/// Groups all styling and builder callbacks that control how the view looks,
/// keeping [DavViewConfig] focused on behavior (time range, scroll, etc.).
///
/// A single decoration can be reused across different day view types (overflow,
/// multi-column, in-row, event-only), making it easy to define branded themes.
class DayViewDecoration {
  /// Width of the time column where times are displayed
  final double timeColumnWidth;

  /// Position of the time column relative to event content
  final TimeColumnPosition timeColumnPosition;

  /// Time label text style
  final TextStyle? timeTextStyle;

  /// Color of time point label
  /// Used as fallback when [timeTextStyle] is null
  final Color? timeTextColor;

  /// Time slot divider color
  final Color? dividerColor;

  /// Color of the current time line
  final Color? currentTimeLineColor;

  /// Custom time label widget per row
  ///
  /// If null, the default time label (12h or 24h format) is used.
  final TimeLabelBuilder? timeLabel;

  /// Custom current time line widget
  ///
  /// If null, the default red line with circle is used.
  final CurrentTimeLineBuilder? currentTimeLine;

  /// Custom background per time row
  ///
  /// Return null from the builder to use the default (transparent) background
  /// for a specific row. Useful for shading lunch break, working hours,
  /// unavailable blocks, etc.
  final TimeRowBackgroundBuilder? rowBackground;

  /// Custom divider between time rows
  ///
  /// Return null from the builder to skip the divider for a specific row.
  /// If this builder itself is null, the default divider is used.
  final DividerBuilder? divider;

  /// Builder for a header widget shown above the scrollable time grid
  final DayViewSectionBuilder? header;

  /// Builder for a footer widget shown below the scrollable time grid
  final DayViewSectionBuilder? footer;

  const DayViewDecoration({
    this.timeColumnWidth = 70,
    this.timeColumnPosition = TimeColumnPosition.left,
    this.timeTextStyle,
    this.timeTextColor,
    this.dividerColor,
    this.currentTimeLineColor,
    this.timeLabel,
    this.currentTimeLine,
    this.rowBackground,
    this.divider,
    this.header,
    this.footer,
  });

  /// Effective time column width — 0 when [timeColumnPosition] is [TimeColumnPosition.none]
  double get effectiveTimeColumnWidth => timeColumnPosition == TimeColumnPosition.none ? 0 : timeColumnWidth;

  DayViewDecoration copyWith({
    double? timeColumnWidth,
    TimeColumnPosition? timeColumnPosition,
    TextStyle? timeTextStyle,
    Color? timeTextColor,
    Color? dividerColor,
    Color? currentTimeLineColor,
    TimeLabelBuilder? timeLabel,
    CurrentTimeLineBuilder? currentTimeLine,
    TimeRowBackgroundBuilder? rowBackground,
    DividerBuilder? divider,
    DayViewSectionBuilder? header,
    DayViewSectionBuilder? footer,
  }) {
    return DayViewDecoration(
      timeColumnWidth: timeColumnWidth ?? this.timeColumnWidth,
      timeColumnPosition: timeColumnPosition ?? this.timeColumnPosition,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      timeTextColor: timeTextColor ?? this.timeTextColor,
      dividerColor: dividerColor ?? this.dividerColor,
      currentTimeLineColor: currentTimeLineColor ?? this.currentTimeLineColor,
      timeLabel: timeLabel ?? this.timeLabel,
      currentTimeLine: currentTimeLine ?? this.currentTimeLine,
      rowBackground: rowBackground ?? this.rowBackground,
      divider: divider ?? this.divider,
      header: header ?? this.header,
      footer: footer ?? this.footer,
    );
  }
}
