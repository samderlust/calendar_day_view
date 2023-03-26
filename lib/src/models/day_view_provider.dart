import 'package:flutter/material.dart';

class DayViewProvider extends InheritedWidget {
  const DayViewProvider({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(child: child, key: key);

  final DayViewState state;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static DayViewProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DayViewProvider>()!;
}

class DayViewState {
  /// To show a line that indicate current hour and minute;
  final bool showCurrentTimeLine;

  /// Color of the current time line
  final Color? currentTimeLineColor;

  /// height in pixel per minute
  final double heightPerMin;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay? endOfDay;

  /// time gap/duration of a row.
  final int timeGap;

  /// color of time point label
  final Color? timeTextColor;

  /// style of time point label
  final TextStyle? timeTextStyle;

  /// time slot divider color
  final Color? dividerColor;

  /// allow render an events row as a ListView
  final bool renderRowAsListView;
  DayViewState({
    this.showCurrentTimeLine = false,
    this.currentTimeLineColor,
    this.heightPerMin = 1.0,
    this.startOfDay = const TimeOfDay(hour: 8, minute: 0),
    this.endOfDay,
    this.timeGap = 60,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
    this.renderRowAsListView = false,
  });

  DayViewState copyWith({
    bool? showCurrentTimeLine,
    Color? currentTimeLineColor,
    double? heightPerMin,
    TimeOfDay? startOfDay,
    TimeOfDay? endOfDay,
    int? timeGap,
    Color? timeTextColor,
    TextStyle? timeTextStyle,
    Color? dividerColor,
    bool? renderRowAsListView,
  }) {
    return DayViewState(
      showCurrentTimeLine: showCurrentTimeLine ?? this.showCurrentTimeLine,
      currentTimeLineColor: currentTimeLineColor ?? this.currentTimeLineColor,
      heightPerMin: heightPerMin ?? this.heightPerMin,
      startOfDay: startOfDay ?? this.startOfDay,
      endOfDay: endOfDay ?? this.endOfDay,
      timeGap: timeGap ?? this.timeGap,
      timeTextColor: timeTextColor ?? this.timeTextColor,
      timeTextStyle: timeTextStyle ?? this.timeTextStyle,
      dividerColor: dividerColor ?? this.dividerColor,
      renderRowAsListView: renderRowAsListView ?? this.renderRowAsListView,
    );
  }

  @override
  String toString() {
    return 'DayViewState(showCurrentTimeLine: $showCurrentTimeLine, currentTimeLineColor: $currentTimeLineColor, heightPerMin: $heightPerMin, startOfDay: $startOfDay, endOfDay: $endOfDay, timeGap: $timeGap, timeTextColor: $timeTextColor, timeTextStyle: $timeTextStyle, dividerColor: $dividerColor, renderRowAsListView: $renderRowAsListView)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DayViewState &&
        other.showCurrentTimeLine == showCurrentTimeLine &&
        other.currentTimeLineColor == currentTimeLineColor &&
        other.heightPerMin == heightPerMin &&
        other.startOfDay == startOfDay &&
        other.endOfDay == endOfDay &&
        other.timeGap == timeGap &&
        other.timeTextColor == timeTextColor &&
        other.timeTextStyle == timeTextStyle &&
        other.dividerColor == dividerColor &&
        other.renderRowAsListView == renderRowAsListView;
  }

  @override
  int get hashCode {
    return showCurrentTimeLine.hashCode ^
        currentTimeLineColor.hashCode ^
        heightPerMin.hashCode ^
        startOfDay.hashCode ^
        endOfDay.hashCode ^
        timeGap.hashCode ^
        timeTextColor.hashCode ^
        timeTextStyle.hashCode ^
        dividerColor.hashCode ^
        renderRowAsListView.hashCode;
  }
}
