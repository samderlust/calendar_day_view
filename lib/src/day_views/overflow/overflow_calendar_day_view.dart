import 'dart:async';

import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../extensions/date_time_extension.dart';
import '../../models/overflow_event.dart';
import '../../models/typedef.dart';
import '../../utils/date_time_utils.dart';
import '../../utils/events_utils.dart';
import '../../widgets/background_ignore_pointer.dart';
import '../../widgets/current_time_line_widget.dart';
import 'widgets/overflow_list_view_row.dart';

class OverFlowCalendarDayView<T extends Object> extends StatefulWidget
    implements CalendarDayView<T> {
  const OverFlowCalendarDayView({
    Key? key,
    required this.options,
    required this.events,
    required this.currentDate,
    this.renderRowAsListView = false,
    this.showMoreOnRowButton = false,
    this.overflowItemBuilder,
    this.moreOnRowButton,
    this.onTimeTap,
    this.primary,
    this.physics,
    this.controller,
    this.cropBottomEvents = true,
  }) :
        //  assert(endOfDay.difference(startOfDay).inHours > 0,
        //     "endOfDay and startOfDay must be at least 1 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        // assert(endOfDay.difference(startOfDay).inHours <= 24,
        //     "endOfDay and startOfDay must be at max 24 hour different. The different now is: ${endOfDay.difference(startOfDay).inHours}"),
        super(key: key);

  final DayViewOptions options;

  /// the date that this dayView is presenting
  final DateTime currentDate;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

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
    timeStart =
        widget.currentDate.copyTimeAndMinClean(widget.options.startOfDay);
    timeEnd = widget.currentDate.copyTimeAndMinClean(widget.options.endOfDay);

    _overflowEvents = processOverflowEvents(
      [...widget.events]..sort((a, b) => a.compare(b)),
      startOfDay:
          widget.currentDate.copyTimeAndMinClean(widget.options.startOfDay),
      endOfDay: widget.currentDate.copyTimeAndMinClean(widget.options.endOfDay),
      cropBottomEvents: widget.cropBottomEvents,
    );

    if (widget.options.showCurrentTimeLine) {
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
    timeStart =
        widget.currentDate.copyTimeAndMinClean(widget.options.startOfDay);
    timeEnd = widget.currentDate.copyTimeAndMinClean(widget.options.endOfDay);
    _overflowEvents = processOverflowEvents(
      [...widget.events]..sort((a, b) => a.compare(b)),
      startOfDay:
          widget.currentDate.copyTimeAndMinClean(widget.options.startOfDay),
      endOfDay: widget.currentDate.copyTimeAndMinClean(widget.options.endOfDay),
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
    final heightUnit = widget.options.heightPerMin * _rowScale;
    final rowHeight =
        widget.options.timeGap * widget.options.heightPerMin * _rowScale;
    final timesInDay = getTimeList(
      timeStart,
      timeEnd,
      widget.options.timeGap,
    );
    final totalHeight = timesInDay.length * rowHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final viewWidth = constraints.maxWidth;
      final eventColumnWith = viewWidth - widget.options.timeTitleColumnWidth;

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
                              color:
                                  widget.options.dividerColor ?? Colors.amber,
                              height: 0,
                              thickness: time.minute == 0 ? 1 : .5,
                              indent: widget.options.timeTitleColumnWidth + 3,
                            ),
                            Transform(
                              transform: Matrix4.translationValues(0, -20, 0),
                              child: SizedBox(
                                height: 40,
                                width: widget.options.timeTitleColumnWidth,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    widget.options.time12
                                        ? time.hourDisplay12
                                        : time.hourDisplay24,
                                    style: widget.options.timeTextStyle ??
                                        TextStyle(
                                            color:
                                                widget.options.timeTextColor),
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
                  child: Stack(
                    // fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: widget.renderRowAsListView
                        ? renderAsListView(
                            heightUnit,
                            eventColumnWith,
                            totalHeight,
                          )
                        : renderWithFixedWidth(heightUnit, eventColumnWith),
                  ),
                ),
                if (widget.options.showCurrentTimeLine &&
                    _currentTime.isAfter(timeStart) &&
                    _currentTime.isBefore(timeEnd))
                  CurrentTimeLineWidget(
                    top: _currentTime.minuteFrom(timeStart).toDouble() *
                        heightUnit,
                    width: constraints.maxWidth,
                    color: widget.options.currentTimeLineColor,
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  List<Widget> renderWithFixedWidth(double heightUnit, double eventColumnWith) {
    final widgets = <Widget>[];

    for (final oEvents in _overflowEvents) {
      final maxHeight =
          (heightUnit * oEvents.start.minuteUntil(oEvents.end).abs());

      for (var i = 0; i < oEvents.events.length; i++) {
        widgets.add(
          Builder(
            builder: (context) {
              final event = oEvents.events.elementAt(i);
              final width = eventColumnWith / oEvents.events.length;
              final topGap = event.minutesFrom(oEvents.start) * heightUnit;

              final tileHeight =
                  (widget.cropBottomEvents && event.end!.isAfter(timeEnd))
                      ? (maxHeight - topGap)
                      : (event.durationInMins * heightUnit);

              final tileConstraints = BoxConstraints(
                maxHeight: tileHeight,
                minHeight: tileHeight,
                minWidth: width,
                maxWidth: eventColumnWith,
              );

              return Positioned(
                left: widget.options.timeTitleColumnWidth +
                    oEvents.events.indexOf(event) * width,
                top: event.minutesFrom(timeStart) * heightUnit,
                child: widget.overflowItemBuilder!(
                  context,
                  tileConstraints,
                  i,
                  event,
                ),
              );
            },
          ),
        );
      }
    }
    return widgets;
  }

// to render all events in same row as a horizontal istView
  List<Widget> renderAsListView(
      double heightUnit, double eventColumnWith, double totalHeight) {
    return [
      for (final oEvents in _overflowEvents)
        Positioned(
          top: oEvents.start.minuteFrom(timeStart) * heightUnit,
          left: widget.options.timeTitleColumnWidth,
          child: OverflowListViewRow(
            totalHeight: totalHeight,
            oEvents: oEvents,
            ignored: widget.onTimeTap != null,
            overflowItemBuilder: widget.overflowItemBuilder!,
            heightUnit: heightUnit,
            eventColumnWith: eventColumnWith,
            showMoreOnRowButton: widget.showMoreOnRowButton,
            moreOnRowButton: widget.moreOnRowButton,
            cropBottomEvents: widget.cropBottomEvents,
          ),
        ),
    ];
  }
}
