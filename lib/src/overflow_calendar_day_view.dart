import 'dart:async';

import 'package:calendar_day_view/src/utils.dart';
import 'package:calendar_day_view/src/widgets/current_time_line_widget.dart';
import 'package:flutter/material.dart';

import 'day_event.dart';
import 'overflow_event.dart';

typedef OverflowItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
  DayEvent<T> event,
);
// const int timeGap = 60;
// const int timeCount = minutesPerDay ~/ timeGap;

class OverFlowCalendarDayView<T extends Object> extends StatefulWidget {
  const OverFlowCalendarDayView({
    Key? key,
    required this.events,
    this.startOfDay = const TimeOfDay(hour: 8, minute: 0),
    this.endOfDay,
    this.timeGap = 60,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
    this.heightPerMin = 1.0,
    this.showCurrentTimeLine = false,
    this.currentTimeLineColor,
    required this.overflowItemBuilder,
  }) : super(key: key);

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

  /// builder for single item
  final OverflowItemBuilder<T> overflowItemBuilder;

  @override
  State<OverFlowCalendarDayView> createState() =>
      _OverFlowCalendarDayViewState<T>();
}

class _OverFlowCalendarDayViewState<T extends Object>
    extends State<OverFlowCalendarDayView<T>> {
  List<TimeOfDay> _timesInDay = [];
  List<OverflowEventsRow<T>> _overflowEvents = [];
  double _heightPerMin = 1.0;
  TimeOfDay _currentTime = TimeOfDay.now();
  Timer? _timer;
  double _rowHeight = 60.0;
  double _rowScale = 1;

  @override
  void initState() {
    super.initState();
    _heightPerMin = widget.heightPerMin;
    _timesInDay = getTimeList();
    _rowHeight = widget.timeGap * _heightPerMin * _rowScale;

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
  void didUpdateWidget(covariant OverFlowCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _rowHeight = widget.timeGap * _heightPerMin * _rowScale;
      _timesInDay = getTimeList();
      _overflowEvents = processOverflowEvents(widget.events
        ..sort(
          (a, b) => a.compare(b),
        ));
      _heightPerMin = widget.heightPerMin;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<TimeOfDay> getTimeList() {
    final timeEnd = widget.endOfDay ?? const TimeOfDay(hour: 24, minute: 0);

    final timeCount =
        ((timeEnd.hour - widget.startOfDay.hour) * 60) ~/ widget.timeGap;

    DateTime first = DateTime.parse(
        "2012-02-27T${widget.startOfDay.hour.toString().padLeft(2, '0')}:00");

    List<TimeOfDay> list = [];
    for (var i = 1; i <= timeCount; i++) {
      list.add(TimeOfDay.fromDateTime(first));
      first = first.add(Duration(minutes: widget.timeGap));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List fixedList = Iterable<int>.generate(_timesInDay.length).toList();

    final heightUnit = _heightPerMin * _rowScale;

    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      final eventColumnWith = viewWidth - 50;

      return SafeArea(
        child: GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              _rowScale = details.scale
                  .clamp(widget.heightPerMin, widget.heightPerMin * 5);

              _rowHeight = widget.timeGap * _heightPerMin * _rowScale;
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: SizedBox(
              height: _timesInDay.length * _rowHeight,
              child: Stack(
                clipBehavior: Clip.none,
                // padding: const EdgeInsets.only(top: 20, bottom: 20),
                children: [
                  ...fixedList.map(
                    (index) {
                      final time = _timesInDay.elementAt(index);

                      return Positioned(
                        top: (index) * _rowHeight,
                        // top: 0,
                        child: SizedBox(
                          height: _rowHeight,
                          width: viewWidth,
                          child: Stack(
                            children: [
                              Divider(
                                color: widget.dividerColor ?? Colors.amber,
                                height: 0,
                                thickness: time.minute == 0 ? 1 : .5,
                                indent: 50,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform(
                                    transform:
                                        Matrix4.translationValues(0, -10, 0),
                                    child: SizedBox(
                                      width: 50,
                                      child: Text(
                                        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}",
                                        style: widget.timeTextStyle ??
                                            TextStyle(
                                                color: widget.timeTextColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Builder(
                    builder: (context) {
                      return Stack(
                        children: [
                          for (final oEvents in _overflowEvents)
                            for (final event in oEvents.events)
                              Builder(
                                builder: (context) {
                                  final width =
                                      eventColumnWith / oEvents.events.length;
                                  return Positioned(
                                    left: 50.0 +
                                        oEvents.events.indexOf(event) * width,
                                    top: event
                                            .minutesFrom(widget.startOfDay)
                                            .toDouble() *
                                        heightUnit,
                                    child: widget.overflowItemBuilder(
                                        context,
                                        BoxConstraints(
                                          maxHeight: event.durationInMins *
                                              _heightPerMin,
                                          minHeight: event.durationInMins *
                                              _heightPerMin,
                                          minWidth: width,
                                          maxWidth: eventColumnWith,
                                        ),
                                        event),
                                  );
                                },
                              ),
                        ],
                      );
                    },
                  ),
                  if (widget.showCurrentTimeLine)
                    CurrentTimeLineWidget(
                      top: minuteFrom(_currentTime, widget.startOfDay)
                              .toDouble() *
                          heightUnit,
                      width: constraints.maxWidth,
                      color: widget.currentTimeLineColor,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
