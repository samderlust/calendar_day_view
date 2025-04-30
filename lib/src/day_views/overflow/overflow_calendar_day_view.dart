import 'dart:async';

import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../extensions/date_time_extension.dart';
import '../../models/overflow_event.dart';
import '../../models/typedef.dart';
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
    this.heightPerMin = 1.0,
    this.overflowItemBuilder,
    this.onTimeTap,
    required this.config,
  }) :
        //  assert(endOfDay.difference(startOfDay).inHours > 0,
        //     "endOfDay and startOfDay must be at least 1 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        // assert(endOfDay.difference(startOfDay).inHours <= 24,
        //     "endOfDay and startOfDay must be at max 24 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        super(key: key);

  final OverFlowDayViewConfig config;

  /// height in pixel per minute
  final double heightPerMin;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

  /// builder for single event
  final DayViewItemBuilder<T>? overflowItemBuilder;

  /// allow user to tap on Day view
  final OnTimeTap? onTimeTap;

  @override
  State<OverFlowCalendarDayView> createState() =>
      _OverFlowCalendarDayViewState<T>();
}

class _OverFlowCalendarDayViewState<T extends Object>
    extends State<OverFlowCalendarDayView<T>> {
  List<OverflowEventsRow<T>> _overflowEvents = [];

  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _overflowEvents = processOverflowEvents(
      [...widget.events]..sort((a, b) => a.compare(b)),
      startOfDay: widget.config.timeStart,
      endOfDay: widget.config.timeEnd,
      cropBottomEvents: widget.config.cropBottomEvents,
    );

    if (widget.config.showCurrentTimeLine) {
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

    _overflowEvents = processOverflowEvents(
      [...widget.events]..sort((a, b) => a.compare(b)),
      startOfDay: widget.config.timeStart,
      endOfDay: widget.config.timeEnd,
      cropBottomEvents: widget.config.cropBottomEvents,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = widget.config.timeList.length * widget.config.rowHeight;
    final viewWidth = MediaQuery.sizeOf(context).width;

    final eventColumnWith = viewWidth - widget.config.timeColumnWidth;

    return SafeArea(
      child: SingleChildScrollView(
        primary: widget.config.primary,
        controller: widget.config.controller,
        physics: widget.config.physics ?? const ClampingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: SizedBox(
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.config.timeList.length,
                itemBuilder: (context, index) {
                  final time = widget.config.timeList.elementAt(index);
                  return OverflowTimeRowWidget(
                    time: time,
                    viewWidth: viewWidth,
                    config: widget.config,
                    onTimeTap: widget.onTimeTap,
                    timeLabelBuilder: widget.config.timeLabelBuilder,
                  );
                },
              ),
              BackgroundIgnorePointer(
                ignored: widget.onTimeTap != null,
                child: widget.config.renderRowAsListView
                    ? OverFlowListViewRowView(
                        overflowEvents: _overflowEvents,
                        overflowItemBuilder: widget.overflowItemBuilder!,
                        heightUnit: widget.config.heightPerMin,
                        eventColumnWith: eventColumnWith,
                        showMoreOnRowButton: widget.config.showMoreOnRowButton,
                        cropBottomEvents: widget.config.cropBottomEvents,
                        timeStart: widget.config.timeStart,
                        totalHeight: totalHeight,
                        timeTitleColumnWidth: widget.config.timeColumnWidth,
                      )
                    : OverflowFixedWidthEventsWidget(
                        heightUnit: widget.config.heightPerMin,
                        eventColumnWidth: eventColumnWith,
                        timeTitleColumnWidth: widget.config.timeColumnWidth,
                        timeStart: widget.config.timeStart,
                        overflowEvents: _overflowEvents,
                        overflowItemBuilder: widget.overflowItemBuilder!,
                        cropBottomEvents: widget.config.cropBottomEvents,
                        timeEnd: widget.config.timeEnd,
                      ),
              ),
              if (widget.config.showCurrentTimeLine &&
                  _currentTime.isAfter(widget.config.timeStart) &&
                  _currentTime.isBefore(widget.config.timeEnd))
                CurrentTimeLineWidget(
                  top: _currentTime
                          .minuteFrom(widget.config.timeStart)
                          .toDouble() *
                      widget.config.heightPerMin,
                  width: viewWidth,
                  color: widget.config.currentTimeLineColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverflowTimeRowWidget extends StatelessWidget {
  const OverflowTimeRowWidget({
    super.key,
    required this.time,
    required this.viewWidth,
    required this.config,
    required this.onTimeTap,
    this.timeLabelBuilder,
  });

  final DateTime time;
  final double viewWidth;
  final OverFlowDayViewConfig config;
  final OnTimeTap? onTimeTap;
  final TimeLabelBuilder? timeLabelBuilder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: ValueKey(time.toString()),
      behavior: HitTestBehavior.opaque,
      onTap: onTimeTap == null ? null : () => onTimeTap!(time),
      child: SizedBox(
        height: config.rowHeight,
        width: viewWidth,
        child: Stack(
          children: [
            Divider(
              color: config.dividerColor ?? Colors.amber,
              height: 0,
              thickness: time.minute == 0 ? 1 : .5,
              indent: config.timeColumnWidth + 3,
            ),
            Transform(
              transform: Matrix4.translationValues(0, -20, 0),
              child: SizedBox(
                height: 40,
                width: config.timeColumnWidth,
                child: Center(
                  child: timeLabelBuilder?.call(context, time) ??
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          config.time12
                              ? time.hourDisplay12
                              : time.hourDisplay24,
                          style: config.timeTextStyle ??
                              TextStyle(color: config.timeTextColor),
                          maxLines: 1,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
