import 'package:flutter/material.dart';

import 'day_event.dart';

const int heightPerMin = 1;
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
  }) : super(key: key);
  final List<DayEvent<T>> events;
  final TimeOfDay startOfDay;
  final TimeOfDay? endOfDay;

  final int timeGap;
  final Color? timeTextColor;
  final TextStyle? timeTextStyle;
  final Color? dividerColor;

  @override
  State<OverFlowCalendarDayView> createState() =>
      _OverFlowCalendarDayViewState<T>();
}

class _OverFlowCalendarDayViewState<T extends Object>
    extends State<OverFlowCalendarDayView<T>> {
  List<TimeOfDay> _timesInDay = [];
  final double _rowHeight = 60.0 * heightPerMin;
  int _minutesPerDay = 60 * 24;

  @override
  void initState() {
    super.initState();
    _timesInDay = getTimeList();
  }

  List<TimeOfDay> getTimeList() {
    final timeEnd = widget.endOfDay ?? const TimeOfDay(hour: 23, minute: 0);
    setState(() {
      _minutesPerDay = (timeEnd.hour - widget.startOfDay.hour) * 60;
    });
    final timeCount =
        ((timeEnd.hour - widget.startOfDay.hour) * 60) ~/ widget.timeGap;

    DateTime first = DateTime.parse(
        "2012-02-27T${widget.startOfDay.hour.toString().padLeft(2, '0')}:${widget.startOfDay.minute.toString().padLeft(2, '0')}");
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

    final Map<int, int> hourIndices = {};
    final Map<Object, double> eventIndices = {};
    final heightUnit = (60 / widget.timeGap);

    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      final eventColumnWith = viewWidth - 50;
      return SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: SizedBox(
            height: _timesInDay.length * 60.0,
            child: Stack(
              clipBehavior: Clip.none,
              // padding: const EdgeInsets.only(top: 20, bottom: 20),
              children: [
                ...fixedList.map(
                  (index) {
                    final time = _timesInDay.elementAt(index);

                    return Positioned(
                      top: (index) * 60.0,
                      // top: 0,
                      child: SizedBox(
                        height: _rowHeight,
                        width: viewWidth,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(0, -10, 0),
                              child: SizedBox(
                                width: 50,
                                child: Text(
                                    "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}"),
                              ),
                            ),
                            Expanded(
                              child:
                                  LayoutBuilder(builder: (context, constrains) {
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: _rowHeight,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        border: const Border(
                                          top: BorderSide(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                for (final event in widget.events)
                  Builder(
                    builder: (context) {
                      hourIndices.update(
                          event.start.hour, (value) => value + 10,
                          ifAbsent: () => 0);
                      eventIndices[event.value.hashCode] =
                          (hourIndices[event.start.hour] ?? 0) * 1.0;

                      return Positioned(
                        left:
                            50.0 + (eventIndices[event.value.hashCode] ?? 0.0),
                        top: event.minutesFrom(widget.startOfDay).toDouble() *
                            heightUnit,
                        child: Container(
                          width: eventColumnWith,
                          height: event.durationInMins * heightUnit,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(.3),
                            border: Border(
                              left: BorderSide(
                                color: Colors.green,
                                width: 10,
                              ),
                            ),
                          ),
                          child: Text(
                            event.value.toString(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
