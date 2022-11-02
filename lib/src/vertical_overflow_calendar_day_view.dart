import 'dart:async';

import 'package:calendar_day_view/src/widgets/background_ignore_pointer.dart';
import 'package:calendar_day_view/src/widgets/overflow_list_view_row.dart';
import 'package:flutter/material.dart';

import 'models/day_event.dart';
import 'models/overflow_event_row.dart';
import 'utils/time_of_day_extension.dart';

import 'utils/utils.dart';
import 'utils/typedef.dart';
import 'widgets/current_time_line_widget.dart';

class VerticalOverFlowCalendarDayView<T extends Object> extends StatefulWidget {
  const VerticalOverFlowCalendarDayView({
    Key? key,
    required this.events,
    this.timeTitleColumnWidth = 20.0,
    this.startOfDay = const TimeOfDay(hour: 8, minute: 0),
    this.endOfDay,
    this.timeGap = 60,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
    this.heightPerMin = 1.0,
    this.showCurrentTimeLine = false,
    this.currentTimeLineColor,
    this.overflowItemBuilder,
    this.renderRowAsListView = false,
    this.showMoreOnRowButton = false,
    this.moreOnRowButton,
    this.onTimeTap,
  }) : super(key: key);

  /// The width of the column that contain list of time points
  final double timeTitleColumnWidth;

  /// To show a line that indicate current hour and minute;
  final bool showCurrentTimeLine;

  /// Color of the current time line
  final Color? currentTimeLineColor;

  /// height in pixel per minute
  final double heightPerMin;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

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

  /// builder for single event
  final DayViewItemBuilder<T>? overflowItemBuilder;

  /// allow render an events row as a ListView
  final bool renderRowAsListView;

  /// allow render button indicate there are more events on the row
  /// also tap to scroll the list to the right
  final bool showMoreOnRowButton;

  /// customized button that indicate there are more events on the row
  final Widget? moreOnRowButton;

  /// allow user to tap on Day view
  final OnTimeTap? onTimeTap;

  @override
  State<VerticalOverFlowCalendarDayView> createState() =>
      _VerticalOverFlowCalendarDayViewState<T>();
}

class _VerticalOverFlowCalendarDayViewState<T extends Object>
    extends State<VerticalOverFlowCalendarDayView<T>> {
  List<TimeOfDay> _timesInDay = [];
  List<OverflowEventsRow<T>> _overflowEvents = [];
  double _heightPerMin = 1.0;
  TimeOfDay _currentTime = TimeOfDay.now();
  Timer? _timer;
  double _rowScale = 1;

  @override
  void initState() {
    super.initState();
    _rowScale = 1;

    _heightPerMin = widget.heightPerMin;
    _timesInDay = getTimeList();

    _overflowEvents = processOverflowEvents(widget.events
      ..sort(
        (a, b) => a.compare(b),
      ));

    if (widget.showCurrentTimeLine) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        setState(() {
          _currentTime = TimeOfDay.now();
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant VerticalOverFlowCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    _timesInDay = getTimeList();
    _overflowEvents = processOverflowEvents(widget.events
      ..sort(
        (a, b) => a.compare(b),
      ));
    _heightPerMin = widget.heightPerMin;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<TimeOfDay> getTimeList() {
    final timeEnd = widget.endOfDay ?? const TimeOfDay(hour: 23, minute: 0);

    final timeCount =
        (((timeEnd.hour + 1) - widget.startOfDay.hour) * 60) ~/ widget.timeGap -
            1;

    DateTime first = DateTime.parse(
        "2012-02-27T${widget.startOfDay.hour.toString().padLeft(2, '0')}:00");

    List<TimeOfDay> list = [];
    for (var i = 0; i <= timeCount; i++) {
      list.add(TimeOfDay.fromDateTime(first));
      first = first.add(Duration(minutes: widget.timeGap));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final widthUnit = _heightPerMin * _rowScale;
    final rowWidth = widget.timeGap * _heightPerMin * _rowScale;

    return LayoutBuilder(builder: (context, constraints) {
      final viewHeigh = constraints.maxHeight;
      final eventColumnHeigh = viewHeigh - widget.timeTitleColumnWidth;

      return SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: SizedBox(
            width: _timesInDay.length * rowWidth,
            child: Stack(
              clipBehavior: Clip.none,
              // padding: const EdgeInsets.only(top: 20, bottom: 20),
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _timesInDay.length,
                  itemBuilder: (context, index) {
                    final time = _timesInDay.elementAt(index);
                    return GestureDetector(
                      key: ValueKey(time.toString()),
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onTimeTap == null
                          ? null
                          : () => widget.onTimeTap!(time),
                      child: SizedBox(
                        width: rowWidth,
                        height: viewHeigh,
                        child: Stack(
                          children: [
                            VerticalDivider(
                              color: widget.dividerColor ?? Colors.amber,
                              width: 0,
                              thickness: time.minute == 0 ? 1 : .5,
                              indent: widget.timeTitleColumnWidth,
                            ),
                            Transform(
                              transform: Matrix4.translationValues(-10, 0, 0),
                              child: SizedBox(
                                height: widget.timeTitleColumnWidth,
                                child: RotatedBox(
                                  quarterTurns: 0,
                                  child: Text(
                                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}",
                                    style: widget.timeTextStyle ??
                                        TextStyle(color: widget.timeTextColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                BackgroundIgnorePointer(
                  ignored: widget.onTimeTap != null,
                  child: Stack(
                    fit: StackFit.expand,
                    children: widget.renderRowAsListView
                        ? renderAsListView(widthUnit, eventColumnHeigh)
                        : renderWithFixedWidth(widthUnit, eventColumnHeigh),
                  ),
                ),
                if (widget.showCurrentTimeLine)
                  CurrentTimeLineWidget(
                    top: _currentTime.minuteFrom(widget.startOfDay).toDouble() *
                        widthUnit,
                    width: constraints.maxWidth,
                    color: widget.currentTimeLineColor,
                  ),
                // GestureDetector(
                //   onScaleUpdate: (details) {
                //     if (details.horizontalScale != _rowScale) {
                //       setState(() {
                //         if (details.scale >= 1 && details.scale <= 10) {
                //           _rowScale = details.scale;
                //         }
                //       });
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> renderWithFixedWidth(double widthUnit, double eventColumnHeigh) {
    return [
      for (final oEvents in _overflowEvents)
        for (final event in oEvents.events)
          Builder(
            builder: (context) {
              final height = eventColumnHeigh / oEvents.events.length;
              return Positioned(
                top: widget.timeTitleColumnWidth +
                    oEvents.events.indexOf(event) * height,
                left:
                    event.minutesFrom(widget.startOfDay).toDouble() * widthUnit,
                child: widget.overflowItemBuilder!(
                  context,
                  BoxConstraints(
                    maxWidth: event.durationInMins * widthUnit,
                    minWidth: event.durationInMins * widthUnit,
                    minHeight: height,
                    maxHeight: height,
                  ),
                  event,
                ),
              );
            },
          ),
    ];
  }

  List<Widget> renderAsListView(double widthUnit, double eventColumnWith) {
    return [
      for (final oEvents in _overflowEvents)
        Positioned(
          left: oEvents.start.minuteFrom(widget.startOfDay) * widthUnit,
          top: widget.timeTitleColumnWidth,
          child: OverflowListViewRow(
            oEvents: oEvents,
            ignored: widget.onTimeTap != null,
            overflowItemBuilder: widget.overflowItemBuilder!,
            heightUnit: widthUnit,
            eventColumnWith: eventColumnWith,
            showMoreOnRowButton: widget.showMoreOnRowButton,
            moreOnRowButton: widget.moreOnRowButton,
            scrollDirection: Axis.vertical,
          ),
        ),
    ];
  }
}
