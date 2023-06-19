import 'dart:async';

import 'package:calendar_day_view/src/extensions/time_of_day_extension.dart';
import 'package:flutter/material.dart';

import '../models/day_event.dart';
import '../models/overflow_event.dart';
import '../models/typedef.dart';
import '../utils/date_time_utils.dart';
import '../utils/events_utils.dart';
import '../widgets/background_ignore_pointer.dart';
import '../widgets/current_time_line_widget.dart';
import '../widgets/overflow_list_view_row.dart';

class OverFlowCalendarDayView<T extends Object> extends StatefulWidget {
  OverFlowCalendarDayView({
    Key? key,
    required this.events,
    this.timeTitleColumnWidth = 50.0,
    required this.startOfDay,
    required this.endOfDay,
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
    this.primary,
    this.physics,
    this.controller,
  })  : assert(endOfDay.difference(startOfDay).inHours > 0,
            "endOfDay and startOfDay must be at least 1 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        assert(endOfDay.difference(startOfDay).inHours <= 24,
            "endOfDay and startOfDay must be at max 24 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        super(key: key);

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
  final DateTime startOfDay;

  /// To set the end time of the day view
  final DateTime endOfDay;

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

  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  @override
  State<OverFlowCalendarDayView> createState() =>
      _OverFlowCalendarDayViewState<T>();
}

class _OverFlowCalendarDayViewState<T extends Object>
    extends State<OverFlowCalendarDayView<T>> {
  List<OverflowEventsRow<T>> _overflowEvents = [];

  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  double _rowScale = 1;

  @override
  void initState() {
    super.initState();
    print(widget.startOfDay);
    print(widget.endOfDay);
    _rowScale = 1;

    _overflowEvents = processOverflowEvents([...widget.events]..sort(
        (a, b) => a.compare(b),
      ));

    if (widget.showCurrentTimeLine) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        setState(() {
          _currentTime = DateTime.now();
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant OverFlowCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _overflowEvents = processOverflowEvents([...widget.events]..sort(
        (a, b) => a.compare(b),
      ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightUnit = widget.heightPerMin * _rowScale;
    final rowHeight = widget.timeGap * widget.heightPerMin * _rowScale;

    final timesInDay =
        getTimeList(widget.startOfDay, widget.endOfDay, widget.timeGap);

    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      final eventColumnWith = viewWidth - widget.timeTitleColumnWidth;

      return SafeArea(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          primary: widget.primary,
          controller: widget.controller,
          physics: widget.physics,
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                height: timesInDay.length * rowHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  // padding: const EdgeInsets.only(top: 20, bottom: 20),
                  children: [
                    ListView.builder(
                      clipBehavior: Clip.none,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: timesInDay.length,
                      itemBuilder: (context, index) {
                        final time = timesInDay.elementAt(index);
                        return GestureDetector(
                          key: ValueKey(time.toString()),
                          behavior: HitTestBehavior.opaque,
                          onTap: widget.onTimeTap == null
                              ? null
                              : () => widget.onTimeTap!(time),
                          child: SizedBox(
                            height: rowHeight,
                            width: viewWidth,
                            child: Stack(
                              children: [
                                Divider(
                                  color: widget.dividerColor ?? Colors.amber,
                                  height: 0,
                                  thickness: time.minute == 0 ? 1 : .5,
                                  indent: widget.timeTitleColumnWidth,
                                ),
                                Transform(
                                  transform:
                                      Matrix4.translationValues(0, -10, 0),
                                  child: SizedBox(
                                    width: widget.timeTitleColumnWidth,
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
                          ),
                        );
                      },
                    ),
                    BackgroundIgnorePointer(
                      ignored: widget.onTimeTap != null,
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: widget.renderRowAsListView
                            ? renderAsListView(heightUnit, eventColumnWith)
                            : renderWithFixedWidth(heightUnit, eventColumnWith),
                      ),
                    ),
                    if (widget.showCurrentTimeLine)
                      CurrentTimeLineWidget(
                        top: _currentTime
                                .minuteFrom(widget.startOfDay)
                                .toDouble() *
                            heightUnit,
                        width: constraints.maxWidth,
                        color: widget.currentTimeLineColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> renderWithFixedWidth(double heightUnit, double eventColumnWith) {
    return [
      for (final oEvents in _overflowEvents)
        for (var i = 0; i < oEvents.events.length; i++)
          Builder(
            builder: (context) {
              final event = oEvents.events.elementAt(i);
              final width = eventColumnWith / oEvents.events.length;
              final tileConstraints = BoxConstraints(
                maxHeight: event.durationInMins * heightUnit,
                minHeight: event.durationInMins * heightUnit,
                minWidth: width,
                maxWidth: eventColumnWith,
              );

              return Positioned(
                left: widget.timeTitleColumnWidth +
                    oEvents.events.indexOf(event) * width,
                top: event.minutesFrom(widget.startOfDay).toDouble() *
                    heightUnit,
                child: widget.overflowItemBuilder!(
                  context,
                  tileConstraints,
                  i,
                  event,
                ),
              );
            },
          ),
    ];
  }

// to render all events in same row as a horizontal istView
  List<Widget> renderAsListView(double heightUnit, double eventColumnWith) {
    return [
      for (final oEvents in _overflowEvents)
        Positioned(
          top: oEvents.start.minuteFrom(widget.startOfDay) * heightUnit,
          left: widget.timeTitleColumnWidth,
          child: OverflowListViewRow(
            oEvents: oEvents,
            ignored: widget.onTimeTap != null,
            overflowItemBuilder: widget.overflowItemBuilder!,
            heightUnit: heightUnit,
            eventColumnWith: eventColumnWith,
            showMoreOnRowButton: widget.showMoreOnRowButton,
            moreOnRowButton: widget.moreOnRowButton,
          ),
        ),
    ];
  }
}
