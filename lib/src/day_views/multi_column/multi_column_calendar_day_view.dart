import 'dart:async';

import 'package:flutter/material.dart';

import '../../../calendar_day_view.dart';
import '../../extensions/date_time_extension.dart';
import '../../utils/multi_column_utils.dart';
import '../../widgets/background_ignore_pointer.dart';
import '../../widgets/current_time_line_widget.dart';

class MultiColumnCalendarDayView<T extends Object> extends StatefulWidget
    implements CalendarDayView<T> {
  const MultiColumnCalendarDayView({
    super.key,
    required this.events,
    required this.itemBuilder,
    this.onTimeTap,
    required this.config,
  });

  final MultiColumnDayViewConfig<T> config;

  /// List of events to be displayed in the day view
  final List<DayEvent<T>> events;

  /// Builder for each event tile
  final MultiColumnItemBuilder<T> itemBuilder;

  /// Allow user to tap on day view time slots
  final OnTimeTap? onTimeTap;

  @override
  State<MultiColumnCalendarDayView> createState() =>
      _MultiColumnCalendarDayViewState<T>();
}

class _MultiColumnCalendarDayViewState<T extends Object>
    extends State<MultiColumnCalendarDayView<T>> {
  List<ColumnEvent<T>> _columnEvents = [];
  DateTime _currentTime = DateTime.now();
  Timer? _timer;
  ScrollController? _autoScrollController;

  @override
  void initState() {
    super.initState();
    _processEvents();

    if (widget.config.showCurrentTimeLine) {
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) {
          setState(() {
            _currentTime = DateTime.now();
          });
        }
      });
    }

    if (widget.config.scrollToCurrentTime) {
      if (widget.config.controller == null) {
        _autoScrollController = ScrollController();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentTime();
      });
    }
  }

  void _processEvents() {
    final strategy = widget.config.overlapStrategy;
    if (strategy != null) {
      _columnEvents = strategy(
        widget.events,
        startOfDay: widget.config.timeStart,
        endOfDay: widget.config.timeEnd,
      );
    } else {
      _columnEvents = assignColumns(
        widget.events,
        startOfDay: widget.config.timeStart,
        endOfDay: widget.config.timeEnd,
      );
    }
  }

  void _scrollToCurrentTime() {
    final now = DateTime.now();
    if (now.isAfter(widget.config.timeStart) &&
        now.isBefore(widget.config.timeEnd)) {
      final offset = now.minuteFrom(widget.config.timeStart).toDouble() *
          widget.config.heightPerMin;
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
  void didUpdateWidget(covariant MultiColumnCalendarDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _processEvents();
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
    final eventColumnWidth = viewWidth - effectiveTimeColumnWidth;
    final eventColumnLeft =
        decoration.timeColumnPosition == TimeColumnPosition.left
            ? effectiveTimeColumnWidth
            : 0.0;

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
                return _MultiColumnTimeRowWidget<T>(
                  time: time,
                  viewWidth: viewWidth,
                  config: widget.config,
                  onTimeTap: widget.onTimeTap,
                );
              },
            ),
            BackgroundIgnorePointer(
              ignored: widget.onTimeTap == null,
              child: Stack(
                clipBehavior: Clip.none,
                children: _buildEventWidgets(
                    context, eventColumnWidth, eventColumnLeft),
              ),
            ),
            if (widget.config.showCurrentTimeLine &&
                _currentTime.isAfter(widget.config.timeStart) &&
                _currentTime.isBefore(widget.config.timeEnd))
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

  List<Widget> _buildEventWidgets(
      BuildContext context, double eventColumnWidth, double eventColumnLeft) {
    return _columnEvents.map((ce) {
      final event = ce.event;
      final top = event.minutesFrom(widget.config.timeStart) *
          widget.config.heightPerMin;

      final columnWidth = eventColumnWidth / ce.totalColumns;
      final left = eventColumnLeft + ce.column * columnWidth;

      var height = event.durationInMins * widget.config.heightPerMin;
      if (widget.config.cropBottomEvents) {
        final eventEnd =
            event.end ?? event.start.add(const Duration(minutes: 30));
        if (eventEnd.isAfter(widget.config.timeEnd)) {
          final maxMinutes =
              widget.config.timeEnd.difference(event.start).inMinutes;
          height = maxMinutes * widget.config.heightPerMin;
        }
      }

      final constraints = BoxConstraints(
        maxHeight: height,
        minHeight: height,
        maxWidth: columnWidth,
        minWidth: columnWidth,
      );

      return Positioned(
        top: top,
        left: left,
        child: widget.itemBuilder(
            context, constraints, event, ce.column, ce.totalColumns),
      );
    }).toList();
  }

  Widget _buildCurrentTimeLine(double viewWidth) {
    final top = _currentTime.minuteFrom(widget.config.timeStart).toDouble() *
        widget.config.heightPerMin;
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

class _MultiColumnTimeRowWidget<T extends Object> extends StatelessWidget {
  const _MultiColumnTimeRowWidget({
    required this.time,
    required this.viewWidth,
    required this.config,
    required this.onTimeTap,
  });

  final DateTime time;
  final double viewWidth;
  final MultiColumnDayViewConfig<T> config;
  final OnTimeTap? onTimeTap;

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
              final roundedTime =
                  time.copyWith(minute: currentMinute + roundedMinute);

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
                      BoxConstraints.tightFor(
                          width: viewWidth, height: config.rowHeight),
                    );
                    return bg ?? const SizedBox.shrink();
                  },
                ),
              ),
            _buildDivider(),
            if (config.decoration.timeColumnPosition != TimeColumnPosition.none)
              _buildTimeLabel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    final decoration = config.decoration;
    if (decoration.divider != null) {
      return Builder(
        builder: (context) =>
            decoration.divider!(context, time) ?? const SizedBox.shrink(),
      );
    }
    final leftIndent = decoration.timeColumnPosition == TimeColumnPosition.left
        ? decoration.effectiveTimeColumnWidth + 3
        : 0.0;
    final rightIndent =
        decoration.timeColumnPosition == TimeColumnPosition.right
            ? decoration.effectiveTimeColumnWidth + 3
            : 0.0;
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
    final label = decoration.timeLabel?.call(context, time) ??
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            config.time12 ? time.hourDisplay12 : time.hourDisplay24,
            style: decoration.timeTextStyle,
            maxLines: 1,
          ),
        );

    final labelBox = SizedBox(
      height: 40,
      width: decoration.timeColumnWidth,
      child: Center(child: label),
    );

    return Positioned(
      left: decoration.timeColumnPosition == TimeColumnPosition.left ? 0 : null,
      right:
          decoration.timeColumnPosition == TimeColumnPosition.right ? 0 : null,
      child: Transform(
        transform: Matrix4.translationValues(0, -20, 0),
        child: labelBox,
      ),
    );
  }
}
