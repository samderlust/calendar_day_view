import 'package:calendar_day_view/src/utils.dart';
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
    required this.overflowItemBuilder,
  }) : super(key: key);
  final List<DayEvent<T>> events;
  final TimeOfDay startOfDay;
  final TimeOfDay? endOfDay;

  final int timeGap;
  final Color? timeTextColor;
  final TextStyle? timeTextStyle;
  final Color? dividerColor;
  final OverflowItemBuilder overflowItemBuilder;

  @override
  State<OverFlowCalendarDayView> createState() =>
      _OverFlowCalendarDayViewState<T>();
}

class _OverFlowCalendarDayViewState<T extends Object>
    extends State<OverFlowCalendarDayView<T>> {
  List<TimeOfDay> _timesInDay = [];
  double _heightPerMin = 1.0;

  List<OverflowEventsRow<T>> _overflowEvents = [];

  @override
  void initState() {
    super.initState();
    _timesInDay = getTimeList();
    _overflowEvents = processOverflowEvents(widget.events
      ..sort(
        (a, b) => a.compare(b),
      ));
  }

  @override
  void didUpdateWidget(covariant OverFlowCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _timesInDay = getTimeList();
      _overflowEvents = processOverflowEvents(widget.events
        ..sort(
          (a, b) => a.compare(b),
        ));
    });
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
    double rowHeight = 60.0 * _heightPerMin;

    final heightUnit = (rowHeight / widget.timeGap);

    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      final eventColumnWith = viewWidth - 50;

      return SafeArea(
        child: GestureDetector(
          onScaleUpdate: (details) {
            setState(() {
              _heightPerMin = (_heightPerMin * details.scale).clamp(0.5, 3);
            });
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: SizedBox(
              height: _timesInDay.length * rowHeight,
              child: Stack(
                clipBehavior: Clip.none,
                // padding: const EdgeInsets.only(top: 20, bottom: 20),
                children: [
                  ...fixedList.map(
                    (index) {
                      final time = _timesInDay.elementAt(index);

                      return Positioned(
                        top: (index) * rowHeight,
                        // top: 0,
                        child: SizedBox(
                          height: rowHeight,
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
                                          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}"),
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
                                          maxHeight:
                                              event.durationInMins * heightUnit,
                                          minHeight:
                                              event.durationInMins * heightUnit,
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
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
