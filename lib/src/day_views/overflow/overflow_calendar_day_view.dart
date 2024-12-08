import 'dart:async';

import '../../../calendar_day_view.dart';
import '../../extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

import '../../models/overflow_event.dart';
import '../../models/typedef.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/events_utils.dart';
import '../../widgets/background_ignore_pointer.dart';
import '../../widgets/current_time_line_widget.dart';
import 'widgets/overflow_fixed_width_events_widget.dart';
import 'widgets/overflow_list_view_row.dart';

class OverFlowCalendarDayView<T extends Object> extends StatefulWidget
    implements CalendarDayView<T> {
  const OverFlowCalendarDayView({
    Key? key,
    required this.events,
    this.timeTitleColumnWidth = 70.0,
    this.startOfDay = const TimeOfDay(hour: 7, minute: 00),
    this.endOfDay = const TimeOfDay(hour: 17, minute: 00),
    this.heightPerMin = 1.0,
    this.timeGap = 60,
    this.showCurrentTimeLine = false,
    this.renderRowAsListView = false,
    this.showMoreOnRowButton = false,
    required this.currentDate,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
    this.currentTimeLineColor,
    this.overflowItemBuilder,
    this.moreOnRowButton,
    this.onTimeTap,
    this.primary,
    this.physics,
    this.controller,
    this.cropBottomEvents = true,
    this.time12 = false,
  }) :
        //  assert(endOfDay.difference(startOfDay).inHours > 0,
        //     "endOfDay and startOfDay must be at least 1 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        // assert(endOfDay.difference(startOfDay).inHours <= 24,
        //     "endOfDay and startOfDay must be at max 24 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
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

  /// the date that this dayView is presenting
  final DateTime currentDate;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay endOfDay;

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

  /// if true, the bottom events' end time will be cropped by the end time of day view
  /// if false, events that have end time after day view end time will have the show the length that pass through day view end time
  final bool cropBottomEvents;

  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  /// show time in 12 hour format
  final bool time12;

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
  late DateTime timeStart;
  late DateTime timeEnd;

  @override
  void initState() {
    super.initState();
    _rowScale = 1;
    timeStart = widget.currentDate.copyTimeAndMinClean(widget.startOfDay);
    timeEnd = widget.currentDate.copyTimeAndMinClean(widget.endOfDay);

    _overflowEvents = processOverflowEvents(
      [...widget.events]..sort((a, b) => a.compare(b)),
      startOfDay: widget.currentDate.copyTimeAndMinClean(widget.startOfDay),
      endOfDay: widget.currentDate.copyTimeAndMinClean(widget.endOfDay),
      cropBottomEvents: widget.cropBottomEvents,
    );

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
    timeStart = widget.currentDate.copyTimeAndMinClean(widget.startOfDay);
    timeEnd = widget.currentDate.copyTimeAndMinClean(widget.endOfDay);

    _overflowEvents = processOverflowEvents(
      [...widget.events]..sort((a, b) => a.compare(b)),
      startOfDay: widget.currentDate.copyTimeAndMinClean(widget.startOfDay),
      endOfDay: widget.currentDate.copyTimeAndMinClean(widget.endOfDay),
      cropBottomEvents: widget.cropBottomEvents,
    );
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
    final timesInDay = getTimeList(
      timeStart,
      timeEnd,
      widget.timeGap,
    );
    final totalHeight = timesInDay.length * rowHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      final eventColumnWith = viewWidth - widget.timeTitleColumnWidth;

      return SafeArea(
        child: SingleChildScrollView(
          primary: widget.primary,
          controller: widget.controller,
          physics: widget.physics ?? const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: SizedBox(
            height: totalHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ListView.builder(
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
                              indent: widget.timeTitleColumnWidth + 3,
                            ),
                            Transform(
                              transform: Matrix4.translationValues(0, -20, 0),
                              child: SizedBox(
                                height: 40,
                                width: widget.timeTitleColumnWidth,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.time12
                                        ? time.hourDisplay12
                                        : time.hourDisplay24,
                                    style: widget.timeTextStyle ??
                                        TextStyle(color: widget.timeTextColor),
                                    maxLines: 1,
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
                  child: widget.renderRowAsListView
                      ? OverFlowListViewRowView(
                          overflowEvents: _overflowEvents,
                          overflowItemBuilder: widget.overflowItemBuilder!,
                          heightUnit: heightUnit,
                          eventColumnWith: eventColumnWith,
                          showMoreOnRowButton: widget.showMoreOnRowButton,
                          cropBottomEvents: widget.cropBottomEvents,
                          timeStart: timeStart,
                          totalHeight: totalHeight,
                          timeTitleColumnWidth: widget.timeTitleColumnWidth,
                        )
                      : OverflowFixedWidthEventsWidget(
                          heightUnit: heightUnit,
                          eventColumnWidth: eventColumnWith,
                          timeTitleColumnWidth: widget.timeTitleColumnWidth,
                          timeStart: timeStart,
                          overflowEvents: _overflowEvents,
                          overflowItemBuilder: widget.overflowItemBuilder!,
                          cropBottomEvents: widget.cropBottomEvents,
                          timeEnd: timeEnd,
                        ),
                ),
                if (widget.showCurrentTimeLine &&
                    _currentTime.isAfter(timeStart) &&
                    _currentTime.isBefore(timeEnd))
                  CurrentTimeLineWidget(
                    top: _currentTime.minuteFrom(timeStart).toDouble() *
                        heightUnit,
                    width: constraints.maxWidth,
                    color: widget.currentTimeLineColor,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
