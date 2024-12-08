import 'dart:async';

import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../extensions/date_time_extension.dart';
import '../models/typedef.dart';
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
    this.itemBuilder,
    this.timeRowBuilder,
    this.onTap,
    required this.config,
  })  : assert(timeRowBuilder != null || itemBuilder != null),
        assert(timeRowBuilder == null || itemBuilder == null),
        super(key: key);

  final InRowDayViewConfig config;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

  /// builder for single item in a time row
  final DayViewItemBuilder<T>? itemBuilder;

  /// builder for single time row (this and [itemBuilder] can not exist at the same time)
  final DayViewTimeRowBuilder<T>? timeRowBuilder;

  /// allow user to tap on Day view
  final OnTimeTap? onTap;

  @override
  State<InRowCalendarDayView> createState() => _InRowCalendarDayViewState<T>();
}

class _InRowCalendarDayViewState<T extends Object>
    extends State<InRowCalendarDayView<T>> {
  DateTime _currentTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.config.showCurrentTimeLine) {
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
        child: ListView.builder(
          clipBehavior: Clip.none,
          primary: widget.config.primary,
          controller: widget.config.controller,
          physics: widget.config.physics ?? const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          itemCount: widget.config.timeList.length,
          itemBuilder: (context, index) {
            final time = widget.config.timeList.elementAt(index);
            final rowEvents = widget.events.where(
              (event) => event.isInThisGap(time, widget.config.timeGap),
            );

            if (rowEvents.isEmpty && widget.config.showWithEventOnly) {
              return const SizedBox.shrink();
            }

            return InRowEventRowWidget(
              viewWidth: viewWidth,
              time: time,
              rowEvents: rowEvents,
              onTap: widget.onTap,
              itemBuilder: widget.itemBuilder,
              timeRowBuilder: widget.timeRowBuilder,
              config: widget.config,
              currentTime: _currentTime,
            );
          },
        ),
      );
    });
  }
}

class InRowEventRowWidget<T extends Object> extends StatelessWidget {
  const InRowEventRowWidget({
    super.key,
    required this.viewWidth,
    required this.time,
    required this.rowEvents,
    required this.onTap,
    required this.itemBuilder,
    required this.timeRowBuilder,
    required this.config,
    required this.currentTime,
  });

  final double viewWidth;
  final DateTime time;
  final Iterable<DayEvent<T>> rowEvents;

  final DateTime currentTime;
  final void Function(DateTime)? onTap;
  final DayViewItemBuilder<T>? itemBuilder;
  final DayViewTimeRowBuilder<T>? timeRowBuilder;
  final InRowDayViewConfig config;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: config.rowHeight,
        maxHeight: config.rowHeight,
        maxWidth: viewWidth,
        minWidth: 0,
      ),
      child: Stack(
        children: [
          Divider(
            color: config.dividerColor ?? Colors.amber,
            height: 0,
            thickness: time.minute == 0 ? 1 : .5,
            indent: config.timeColumnWidth + 3,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform(
                transform: Matrix4.translationValues(0, -20, 0),
                child: SizedBox(
                  height: 40,
                  width: config.timeColumnWidth,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      config.time12 ? time.hourDisplay12 : time.hourDisplay24,
                      style: config.timeTextStyle,
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
                        maxHeight: config.rowHeight,
                        maxWidth: constrains.maxWidth / rowEvents.length,
                      );

                      return SizedBox(
                        height: config.rowHeight,
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
          if (config.showCurrentTimeLine &&
              currentTime.inTheGap(time, config.timeGap))
            CurrentTimeLineWidget(
              top: (currentTime.minute - time.minute) * config.heightPerMin,
              color: config.currentTimeLineColor,
              width: viewWidth,
            ),
        ],
      ),
    );
  }
}
