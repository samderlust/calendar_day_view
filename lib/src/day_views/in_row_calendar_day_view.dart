import 'dart:async';

import '../extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../models/typedef.dart';
import '../utils/date_time_utils.dart';
import '../widgets/current_time_line_widget.dart';

/// Show events in a time gap window in a single row
///
/// ex: if [timeGap] is 15, the events that have start time from `10:00` to `10:15`
/// will be displayed in the same row.
class InRowCalendarDayView<T extends Object> extends StatefulWidget
    implements CalendarDayView<T> {
  const InRowCalendarDayView({
    Key? key,
    required this.events,
    this.startOfDay = const TimeOfDay(hour: 7, minute: 00),
    this.endOfDay = const TimeOfDay(hour: 17, minute: 00),
    required this.currentDate,
    this.showWithEventOnly = false,
    this.timeGap = 60,
    this.timeTextColor,
    this.timeTextStyle,
    this.itemBuilder,
    this.dividerColor,
    this.timeRowBuilder,
    this.heightPerMin = 2.0,
    this.showCurrentTimeLine = false,
    this.currentTimeLineColor,
    this.onTap,
    this.primary,
    this.physics,
    this.timeTitleColumnWidth = 50.0,
    this.controller,
    this.time12 = false,
  })  : assert(timeRowBuilder != null || itemBuilder != null),
        assert(timeRowBuilder == null || itemBuilder == null),
        super(key: key);

  /// To show a line that indicate current hour and minute;
  final bool showCurrentTimeLine;

  /// Color of the current time line
  final Color? currentTimeLineColor;

  /// height in pixel per minute
  final double heightPerMin;

  /// the date that this dayView is presenting
  final DateTime currentDate;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

  /// To set the start time of the day view
  final TimeOfDay startOfDay;

  /// To set the end time of the day view
  final TimeOfDay endOfDay;

  /// if true, only display row with events. Default to false
  final bool showWithEventOnly;

  /// time gap/duration of a row.
  final int timeGap;

  /// color of time point label
  final Color? timeTextColor;

  /// style of time point label
  final TextStyle? timeTextStyle;

  /// time slot divider color
  final Color? dividerColor;

  /// builder for single item in a time row
  final DayViewItemBuilder<T>? itemBuilder;

  /// builder for single time row (this and [itemBuilder] can not exist at the same time)
  final DayViewTimeRowBuilder<T>? timeRowBuilder;

  /// allow user to tap on Day view
  final OnTimeTap? onTap;

  final bool? primary;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  /// show time in 12 hour format
  final bool time12;

  /// The width of the column that contain list of time points
  final double timeTitleColumnWidth;

  @override
  State<InRowCalendarDayView> createState() => _InRowCalendarDayViewState<T>();
}

class _InRowCalendarDayViewState<T extends Object>
    extends State<InRowCalendarDayView<T>> {
  List<DateTime> _timesInDay = [];
  double _heightPerMin = 1;
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  double _rowHeight = 60.0;
  double _rowScale = 1;

  late DateTime timeStart;
  late DateTime timeEnd;

  @override
  void initState() {
    super.initState();
    _heightPerMin = widget.heightPerMin;
    timeStart = widget.currentDate.copyTimeAndMinClean(widget.startOfDay);
    timeEnd = widget.currentDate.copyTimeAndMinClean(widget.endOfDay);

    _timesInDay = getTimeList(timeStart, timeEnd, widget.timeGap);

    _rowHeight = widget.timeGap * _heightPerMin * _rowScale;

    if (widget.showCurrentTimeLine) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        setState(() {
          _currentTime = DateTime.now();
        });
      });
    }
  }

  @override
  void didUpdateWidget(covariant InRowCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    timeStart = widget.currentDate.copyTimeAndMinClean(widget.startOfDay);
    timeEnd = widget.currentDate.copyTimeAndMinClean(widget.endOfDay);
    _timesInDay = getTimeList(timeStart, timeEnd, widget.timeGap);

    _heightPerMin = widget.heightPerMin;
    _rowHeight = widget.timeGap * _heightPerMin * _rowScale;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;

      return SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onScaleUpdate: (details) {
            setState(() {
              _rowScale =
                  details.verticalScale; //.clamp(1, widget.heightPerMin * 4);
              _rowHeight =
                  widget.timeGap * _heightPerMin * details.verticalScale;
            });
          },
          child: ListView.builder(
            clipBehavior: Clip.none,
            primary: widget.primary,
            controller: widget.controller,
            physics: widget.physics ?? const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            itemCount: _timesInDay.length,
            itemBuilder: (context, index) {
              final time = _timesInDay.elementAt(index);
              final rowEvents = widget.events.where(
                (event) => event.isInThisGap(time, widget.timeGap),
              );

              if (rowEvents.isEmpty && widget.showWithEventOnly) {
                return const SizedBox.shrink();
              }

              return InRowEventRowWidget(
                rowHeight: _rowHeight,
                viewWidth: viewWidth,
                time: time,
                rowEvents: rowEvents,
                currentTime: _currentTime,
                heightPerMin: _heightPerMin,
                dividerColor: widget.dividerColor,
                timeTextStyle: widget.timeTextStyle,
                timeTextColor: widget.timeTextColor,
                time12: widget.time12,
                timeTitleColumnWidth: widget.timeTitleColumnWidth,
                onTap: widget.onTap,
                showCurrentTimeLine: widget.showCurrentTimeLine,
                currentTimeLineColor: widget.currentTimeLineColor,
                itemBuilder: widget.itemBuilder,
                timeRowBuilder: widget.timeRowBuilder,
                timeGap: widget.timeGap,
              );
            },
          ),
        ),
      );
    });
  }
}

class InRowEventRowWidget<T extends Object> extends StatelessWidget {
  const InRowEventRowWidget({
    super.key,
    required this.rowHeight,
    required this.viewWidth,
    required this.time,
    required this.rowEvents,
    required this.currentTime,
    required this.heightPerMin,
    required this.dividerColor,
    required this.timeTextStyle,
    required this.timeTextColor,
    required this.time12,
    required this.timeTitleColumnWidth,
    required this.onTap,
    required this.showCurrentTimeLine,
    required this.currentTimeLineColor,
    required this.itemBuilder,
    required this.timeRowBuilder,
    required this.timeGap,
  });

  final double rowHeight;
  final double viewWidth;
  final DateTime time;
  final Iterable<DayEvent<T>> rowEvents;
  final DateTime currentTime;
  final double heightPerMin;
  final Color? dividerColor;
  final TextStyle? timeTextStyle;
  final Color? timeTextColor;
  final bool time12;
  final double timeTitleColumnWidth;
  final void Function(DateTime)? onTap;
  final bool showCurrentTimeLine;
  final Color? currentTimeLineColor;
  final DayViewItemBuilder<T>? itemBuilder;
  final DayViewTimeRowBuilder<T>? timeRowBuilder;
  final int timeGap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: rowHeight,
        maxHeight: rowHeight,
        maxWidth: viewWidth,
        minWidth: 0,
      ),
      child: Stack(
        children: [
          Divider(
            color: dividerColor ?? Colors.amber,
            height: 0,
            thickness: time.minute == 0 ? 1 : .5,
            indent: timeTitleColumnWidth + 3,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform(
                transform: Matrix4.translationValues(0, -20, 0),
                child: SizedBox(
                  height: 40,
                  width: timeTitleColumnWidth,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      time12 ? time.hourDisplay12 : time.hourDisplay24,
                      style: timeTextStyle ?? TextStyle(color: timeTextColor),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onTap == null ? null : () => onTap!(time),
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      final tileConstraints = BoxConstraints(
                        maxHeight: rowHeight,
                        maxWidth: constrains.maxWidth / rowEvents.length,
                      );

                      return SizedBox(
                        height: rowHeight,
                        child: Builder(
                          builder: (context) {
                            if (timeRowBuilder != null) {
                              return timeRowBuilder!(
                                context,
                                constrains,
                                rowEvents.toList(),
                              );
                            } else {
                              return Row(
                                children: [
                                  for (var i = 0; i < rowEvents.length; i++)
                                    itemBuilder!(
                                      context,
                                      tileConstraints,
                                      i,
                                      rowEvents.elementAt(i),
                                    )
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (showCurrentTimeLine && currentTime.inTheGap(time, timeGap))
            CurrentTimeLineWidget(
              top: (currentTime.minute - time.minute) * heightPerMin,
              color: currentTimeLineColor,
              width: viewWidth,
            ),
        ],
      ),
    );
  }
}
