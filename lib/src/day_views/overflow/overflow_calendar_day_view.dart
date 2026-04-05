import 'dart:async';

import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../extensions/date_time_extension.dart';
import '../../models/overflow_event.dart';
import '../../utils/events_utils.dart';
import '../../widgets/background_ignore_pointer.dart';
import '../../widgets/current_time_line_widget.dart';

import 'widgets/overflow_fixed_width_events_widget.dart';
import 'widgets/overflow_list_view_row.dart';

class OverFlowCalendarDayView<T extends Object> extends StatefulWidget implements CalendarDayView<T> {
  const OverFlowCalendarDayView({
    super.key,
    required this.events,
    this.overflowItemBuilder,
    this.onTimeTap,
    required this.config,
  });

  final OverFlowDayViewConfig config;

  /// List of events to be display in the day view
  final List<DayEvent<T>> events;

  /// builder for single event
  final DayViewItemBuilder<T>? overflowItemBuilder;

  /// allow user to tap on Day view
  final OnTimeTap? onTimeTap;

  @override
  State<OverFlowCalendarDayView> createState() => _OverFlowCalendarDayViewState<T>();
}

class _OverFlowCalendarDayViewState<T extends Object> extends State<OverFlowCalendarDayView<T>> {
  List<OverflowEventsRow<T>> _overflowEvents = [];

  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  ScrollController? _autoScrollController;

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
        if (mounted) {
          setState(() {
            _currentTime = DateTime.now();
          });
        }
      });
    }

    if (widget.config.scrollToCurrentTime && widget.config.controller == null) {
      _autoScrollController = ScrollController();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentTime();
      });
    } else if (widget.config.scrollToCurrentTime && widget.config.controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentTime();
      });
    }
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    if (now.isAfter(widget.config.timeStart) && now.isBefore(widget.config.timeEnd)) {
      final offset = now.minuteFrom(widget.config.timeStart).toDouble() * widget.config.heightPerMin;
      // Offset a bit above current time so it's not at the very top
      final scrollOffset = (offset - 50).clamp(0.0, double.infinity);
      final ctrl = widget.config.controller ?? _autoScrollController;
      if (ctrl != null && ctrl.hasClients) {
        ctrl.animateTo(
          scrollOffset.clamp(0.0, ctrl.position.maxScrollExtent),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
    _autoScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.config.decoration;
    final totalHeight = widget.config.timeList.length * widget.config.rowHeight;
    final viewWidth = MediaQuery.sizeOf(context).width;

    final effectiveTimeColumnWidth = decoration.effectiveTimeColumnWidth;
    final eventColumnWith = viewWidth - effectiveTimeColumnWidth;
    final eventColumnLeft = decoration.timeColumnPosition == TimeColumnPosition.left ? effectiveTimeColumnWidth : 0.0;

    final scrollView = SingleChildScrollView(
      primary: widget.config.primary,
      controller: widget.config.controller ?? _autoScrollController,
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
                  timeLabelBuilder: decoration.timeLabel,
                );
              },
            ),
            BackgroundIgnorePointer(
              ignored: widget.onTimeTap == null,
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
                      timeTitleColumnWidth: eventColumnLeft,
                    )
                  : OverflowFixedWidthEventsWidget(
                      heightUnit: widget.config.heightPerMin,
                      eventColumnWidth: eventColumnWith,
                      timeTitleColumnWidth: eventColumnLeft,
                      timeStart: widget.config.timeStart,
                      overflowEvents: _overflowEvents,
                      overflowItemBuilder: widget.overflowItemBuilder!,
                      cropBottomEvents: widget.config.cropBottomEvents,
                      timeEnd: widget.config.timeEnd,
                    ),
            ),
            if (widget.config.showCurrentTimeLine && _currentTime.isAfter(widget.config.timeStart) && _currentTime.isBefore(widget.config.timeEnd))
              _buildCurrentTimeLine(viewWidth),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          if (decoration.header != null) decoration.header!(context),
          Expanded(child: scrollView),
          if (decoration.footer != null) decoration.footer!(context),
        ],
      ),
    );
  }

  Widget _buildCurrentTimeLine(double viewWidth) {
    final top = _currentTime.minuteFrom(widget.config.timeStart).toDouble() * widget.config.heightPerMin;
    if (widget.config.decoration.currentTimeLine != null) {
      return widget.config.decoration.currentTimeLine!(top, viewWidth);
    }
    return CurrentTimeLineWidget(
      top: top,
      width: viewWidth,
      color: widget.config.decoration.currentTimeLineColor,
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
      onTapDown: onTimeTap == null
          ? null
          : (details) {
              final localYPosition = details.localPosition.dy;
              final rowHeight = config.rowHeight;
              final timeGap = config.timeGap;

              final minuteFraction = (localYPosition / rowHeight) * timeGap;
              final roundedMinute = (minuteFraction / 5).round() * 5;
              final currentMinute = time.minute;
              final roundedTime = time.copyWith(minute: currentMinute + roundedMinute);

              onTimeTap!(roundedTime);
            },
      child: SizedBox(
        height: config.rowHeight,
        width: viewWidth,
        child: Stack(
          children: [
            if (config.decoration.rowBackground != null)
              Positioned.fill(
                child: Builder(
                  builder: (context) {
                    final bg = config.decoration.rowBackground!(
                      context,
                      time,
                      BoxConstraints.tightFor(width: viewWidth, height: config.rowHeight),
                    );
                    return bg ?? const SizedBox.shrink();
                  },
                ),
              ),
            _buildDivider(config, time),
            if (config.decoration.timeColumnPosition != TimeColumnPosition.none) _buildTimeLabel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(OverFlowDayViewConfig config, DateTime time) {
    final decoration = config.decoration;
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
      thickness: time.minute == 0 ? 1 : .5,
      indent: leftIndent,
      endIndent: rightIndent,
    );
  }

  Widget _buildTimeLabel(BuildContext context) {
    final decoration = config.decoration;
    final label = timeLabelBuilder?.call(context, time) ??
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            config.time12 ? time.hourDisplay12 : time.hourDisplay24,
            style: decoration.timeTextStyle ?? TextStyle(color: decoration.timeTextColor),
            maxLines: 1,
          ),
        );

    final labelBox = SizedBox(
      height: 40,
      width: decoration.timeColumnWidth,
      child: Center(child: label),
    );

    if (decoration.timeColumnPosition == TimeColumnPosition.right) {
      return Positioned(
        right: 0,
        top: -20,
        child: labelBox,
      );
    }
    return Transform(
      transform: Matrix4.translationValues(0, -20, 0),
      child: labelBox,
    );
  }
}
