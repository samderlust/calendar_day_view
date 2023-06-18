import 'dart:async';

import 'package:flutter/material.dart';

import '../extensions/time_of_day_extension.dart';
import '../models/day_event.dart';
import '../models/typedef.dart';
import '../utils/date_time_utils.dart';
import '../widgets/current_time_line_widget.dart';

/// Show events in a time gap window in a single row
///
/// ex: if [timeGap] is 15, the events that have start time from `10:00` to `10:15`
/// will be displayed in the same row.
class InRowCalendarDayView<T extends Object> extends StatefulWidget {
  const InRowCalendarDayView({
    Key? key,
    required this.events,
    required this.startOfDay,
    required this.endOfDay,
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
    this.controller,
  })  : assert(timeRowBuilder != null || itemBuilder != null),
        assert(timeRowBuilder == null || itemBuilder == null),
        super(key: key);

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

  @override
  void initState() {
    super.initState();
    _heightPerMin = widget.heightPerMin;
    _timesInDay =
        getTimeList(widget.startOfDay, widget.endOfDay, widget.timeGap);
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
    _timesInDay =
        getTimeList(widget.startOfDay, widget.endOfDay, widget.timeGap);
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
            primary: widget.primary,
            controller: widget.controller,
            physics: widget.physics,
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

              return ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: _rowHeight,
                  maxHeight: _rowHeight,
                  maxWidth: viewWidth,
                  minWidth: 0,
                ),
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
                          transform: Matrix4.translationValues(0, -10, 0),
                          child: SizedBox(
                            width: 50,
                            child: Text(
                              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}",
                              style: widget.timeTextStyle ??
                                  TextStyle(color: widget.timeTextColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onTap == null
                                ? null
                                : () => widget.onTap!(time),
                            child: LayoutBuilder(
                              builder: (context, constrains) {
                                final tileConstraints = BoxConstraints(
                                  maxHeight: _rowHeight,
                                  maxWidth:
                                      constrains.maxWidth / rowEvents.length,
                                );

                                return SizedBox(
                                  height: _rowHeight,
                                  child: Builder(
                                    builder: (context) {
                                      if (widget.timeRowBuilder != null) {
                                        return widget.timeRowBuilder!(
                                          context,
                                          constrains,
                                          rowEvents.toList(),
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            for (var i = 0;
                                                i < rowEvents.length;
                                                i++)
                                              widget.itemBuilder!(
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
                    if (widget.showCurrentTimeLine &&
                        _currentTime.inTheGap(time, widget.timeGap))
                      CurrentTimeLineWidget(
                        top:
                            (_currentTime.minute - time.minute) * _heightPerMin,
                        color: widget.currentTimeLineColor,
                        width: viewWidth,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
