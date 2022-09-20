import 'package:flutter/material.dart';

import 'day_event.dart';

typedef EventDayViewItemBuilder<T extends Object> = Widget Function(
  BuildContext context,
  DayEvent<T> event,
);

/// Day View that only show time slot with Events
///
/// this day view doesn't display with a fixed time gap
/// it listed and sorted by the time that the events start
class EventCalendarDayView<T extends Object> extends StatefulWidget {
  const EventCalendarDayView({
    Key? key,
    required this.events,
    required this.eventDayViewItemBuilder,
    this.timeTextColor,
    this.timeTextStyle,
    this.dividerColor,
    this.itemSeparatorBuilder,
    this.rowPadding,
    this.timeSlotPadding,
  }) : super(key: key);

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

  /// color of time point label
  final Color? timeTextColor;

  /// style of time point label
  final TextStyle? timeTextStyle;

  /// builder for each item
  final EventDayViewItemBuilder<T> eventDayViewItemBuilder;

  /// build separator between each item
  final IndexedWidgetBuilder? itemSeparatorBuilder;

  /// time slot divider color
  final Color? dividerColor;

  /// padding for event row
  final EdgeInsetsGeometry? rowPadding;

  ///padding for time slot
  final EdgeInsetsGeometry? timeSlotPadding;

  @override
  State<EventCalendarDayView> createState() => _EventCalendarDayViewState<T>();
}

class _EventCalendarDayViewState<T extends Object>
    extends State<EventCalendarDayView<T>> {
  List<TimeOfDay> _timesInDay = [];

  @override
  void initState() {
    super.initState();
    _timesInDay = getTimeList();
  }

  List<TimeOfDay> getTimeList() {
    Set<TimeOfDay> list = {};
    list.addAll(widget.events.map((e) => e.start).toList()
      ..sort(
        (a, b) {
          if (a.hour > b.hour) return 1;
          if (a.hour == b.hour && a.minute > b.minute) return 1;
          return -1;
        },
      ));
    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          children: _timesInDay.map(
            (time) {
              final events = widget.events.where(
                (event) => event.startAt(time),
              );

              return Padding(
                padding: widget.timeSlotPadding ??
                    const EdgeInsets.symmetric(vertical: 5),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Divider(
                      color: widget.dividerColor ?? Colors.amber,
                      height: 0,
                      thickness: 1,
                      indent: 40,
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
                          child: Padding(
                            padding:
                                widget.rowPadding ?? const EdgeInsets.all(0),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: events.length,
                              separatorBuilder: widget.itemSeparatorBuilder ??
                                  (context, index) => const SizedBox(height: 5),
                              itemBuilder: (context, index) {
                                return widget.eventDayViewItemBuilder(
                                  context,
                                  events.elementAt(index),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      );
    });
  }
}
