import 'package:calendar_day_view/src/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';

/// Day View that only show time slot with Events
///
/// this day view doesn't display with a fixed time gap
/// it listed and sorted by the time that the events start
class EventCalendarDayView<T extends Object> extends StatefulWidget implements CalendarDayView<T> {
  const EventCalendarDayView({
    super.key,
    required this.events,
    required this.eventDayViewItemBuilder,
    this.itemSeparatorBuilder,
    required this.config,
  });

  final EventDayViewConfig config;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

  /// builder for each item
  final EventDayViewItemBuilder<T> eventDayViewItemBuilder;

  /// build separator between each item
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  @override
  State<EventCalendarDayView> createState() => _EventCalendarDayViewState<T>();
}

class _EventCalendarDayViewState<T extends Object> extends State<EventCalendarDayView<T>> {
  List<DateTime> _timesInDay = [];

  @override
  void initState() {
    super.initState();
    _timesInDay = getTimeList();
  }

  List<DateTime> getTimeList() {
    final Set<DateTime> list = {};
    list.addAll(widget.events.map((e) => widget.config.showHourly ? e.start.hourOnly() : e.start.cleanSec()).toList()
      ..sort(
        (a, b) {
          final hourComparison = a.hour.compareTo(b.hour);
          if (hourComparison != 0) {
            return hourComparison;
          } else {
            return a.minute.compareTo(b.minute);
          }
        },
      ));
    return list.toList();
  }

  @override
  void didUpdateWidget(covariant EventCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _timesInDay = getTimeList();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.config.decoration;
    return LayoutBuilder(
      builder: (context, constraints) {
        final listView = ListView.builder(
          shrinkWrap: true,
          primary: widget.config.primary,
          controller: widget.config.controller,
          physics: widget.config.physics ?? const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: _timesInDay.length,
          itemBuilder: (context, index) {
            final time = _timesInDay.elementAt(index);
            final events = widget.events.where(
              (event) => widget.config.showHourly ? event.startAtHour(time) : event.startAt(time),
            );
            return Padding(
              padding: widget.config.timeSlotPadding ?? const EdgeInsets.symmetric(vertical: 5),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildDivider(time),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildRowChildren(context, time, events),
                  ),
                ],
              ),
            );
          },
        );

        return SafeArea(
          child: Column(
            children: [
              if (decoration.header != null) decoration.header!(context),
              Expanded(child: listView),
              if (decoration.footer != null) decoration.footer!(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider(DateTime time) {
    final decoration = widget.config.decoration;
    if (decoration.divider != null) {
      return Builder(
        builder: (context) => decoration.divider!(context, time) ?? const SizedBox.shrink(),
      );
    }
    final leftIndent = decoration.timeColumnPosition == TimeColumnPosition.left ? decoration.effectiveTimeColumnWidth + 3 : 0.0;
    final rightIndent = decoration.timeColumnPosition == TimeColumnPosition.right ? decoration.effectiveTimeColumnWidth + 3 : 0.0;
    return Divider(
      color: decoration.dividerColor ?? Colors.amber,
      height: 0,
      thickness: 1,
      indent: leftIndent,
      endIndent: rightIndent,
    );
  }

  Widget _buildTimeLabel(BuildContext context, DateTime time) {
    final decoration = widget.config.decoration;
    return Transform(
      transform: Matrix4.translationValues(0, -20, 0),
      child: SizedBox(
        height: 40,
        width: decoration.timeColumnWidth,
        child: decoration.timeLabel?.call(context, time) ??
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.config.time12 ? time.hourDisplay12 : time.hourDisplay24,
                style: decoration.timeTextStyle,
                maxLines: 1,
              ),
            ),
      ),
    );
  }

  Widget _buildEventsArea(Iterable<DayEvent<T>> events) {
    return Expanded(
      child: Padding(
        padding: widget.config.rowPadding ?? const EdgeInsets.all(0),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: events.length,
          separatorBuilder: widget.itemSeparatorBuilder ?? (context, index) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            return widget.eventDayViewItemBuilder(
              context,
              index,
              events.elementAt(index),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildRowChildren(BuildContext context, DateTime time, Iterable<DayEvent<T>> events) {
    final position = widget.config.decoration.timeColumnPosition;
    final eventsArea = _buildEventsArea(events);
    switch (position) {
      case TimeColumnPosition.left:
        return [_buildTimeLabel(context, time), eventsArea];
      case TimeColumnPosition.right:
        return [eventsArea, _buildTimeLabel(context, time)];
      case TimeColumnPosition.none:
        return [eventsArea];
    }
  }
}
