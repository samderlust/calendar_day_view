import 'package:calendar_day_view/src/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

import '../../../models/day_event.dart';
import '../../../models/overflow_event.dart';
import '../../../models/typedef.dart';
import '../../../widgets/background_ignore_pointer.dart';

class OverFlowListViewRowView<T extends Object> extends StatelessWidget {
  const OverFlowListViewRowView({
    super.key,
    required this.overflowEvents,
    required this.overflowItemBuilder,
    required this.heightUnit,
    required this.eventColumnWith,
    required this.showMoreOnRowButton,
    this.moreOnRowButton,
    required this.cropBottomEvents,
    required this.timeStart,
    required this.totalHeight,
    required this.timeTitleColumnWidth,
    this.onTimeTap,
  });

  final List<OverflowEventsRow<T>> overflowEvents;
  final DayViewItemBuilder<T> overflowItemBuilder;
  final double heightUnit;
  final double eventColumnWith;
  final bool showMoreOnRowButton;
  final Widget? moreOnRowButton;
  final bool cropBottomEvents;
  final DateTime timeStart;
  final double totalHeight;
  final double timeTitleColumnWidth;
  final Function(DateTime, T)? onTimeTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (final oEvents in overflowEvents)
          Positioned(
            top: oEvents.start.minuteFrom(timeStart) * heightUnit,
            left: timeTitleColumnWidth,
            child: OverflowListViewRow(
              totalHeight: totalHeight,
              oEvents: oEvents,
              ignored: onTimeTap != null,
              overflowItemBuilder: overflowItemBuilder,
              heightUnit: heightUnit,
              eventColumnWith: eventColumnWith,
              showMoreOnRowButton: showMoreOnRowButton,
              moreOnRowButton: moreOnRowButton,
              cropBottomEvents: cropBottomEvents,
            ),
          ),
      ],
    );
  }
}

class OverflowListViewRow<T extends Object> extends StatefulWidget {
  const OverflowListViewRow({
    Key? key,
    required this.oEvents,
    required this.overflowItemBuilder,
    required this.heightUnit,
    required this.eventColumnWith,
    required this.showMoreOnRowButton,
    this.moreOnRowButton,
    required this.ignored,
    required this.totalHeight,
    required this.cropBottomEvents,
  }) : super(key: key);

  final OverflowEventsRow<T> oEvents;
  final DayViewItemBuilder<T> overflowItemBuilder;
  final double heightUnit;
  final double eventColumnWith;
  final double totalHeight;
  final Widget? moreOnRowButton;
  final bool showMoreOnRowButton;

  final bool cropBottomEvents;

  final bool ignored;

  @override
  State<OverflowListViewRow<T>> createState() => _OverflowListViewRowState<T>();
}

class _OverflowListViewRowState<T extends Object>
    extends State<OverflowListViewRow<T>> {
  late ScrollController _scrollCtrl;
  bool _atEndOfList = true;

  @override
  void initState() {
    super.initState();
    _atEndOfList = true;
    _scrollCtrl = ScrollController();

    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        if (!_atEndOfList) {
          setState(() {
            _atEndOfList = true;
          });
        }
      } else {
        if (_atEndOfList) {
          setState(() {
            _atEndOfList = false;
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_scrollCtrl.hasClients &&
          _scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent) {
        setState(() {
          _atEndOfList = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = (widget.heightUnit *
        widget.oEvents.start.minuteUntil(widget.oEvents.end).abs());

    return Container(
      width: widget.eventColumnWith,
      height: maxHeight,
      constraints: BoxConstraints(
        maxHeight: maxHeight,
        minHeight: maxHeight,
      ),
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollCtrl,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.oEvents.events.length,
            itemBuilder: (context, index) {
              final event = widget.oEvents.events.elementAt(index);
              final width =
                  widget.eventColumnWith / widget.oEvents.events.length;
              final topGap = event.start.minuteFrom(widget.oEvents.start) *
                  widget.heightUnit;

              final tilePossibleHeight =
                  (event.durationInMins * widget.heightUnit);

              final tileHeight = (maxHeight < (topGap + tilePossibleHeight) &&
                      widget.cropBottomEvents)
                  ? (maxHeight - topGap)
                  : (event.durationInMins * widget.heightUnit);

              final tileConstraints = BoxConstraints(
                maxHeight: tileHeight,
                minHeight: tileHeight,
                minWidth: width,
                maxWidth: widget.eventColumnWith,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: topGap),
                  StopBackgroundIgnorePointer(
                    ignored: widget.ignored,
                    child: widget.overflowItemBuilder(
                      context,
                      tileConstraints,
                      index,
                      event,
                    ),
                  ),
                ],
              );
            },
          ),
          if (widget.showMoreOnRowButton)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  _scrollCtrl.animateTo(
                    (_scrollCtrl.offset + (widget.eventColumnWith - 10)).clamp(
                      0,
                      _scrollCtrl.position.maxScrollExtent,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: AnimatedOpacity(
                  opacity: _atEndOfList ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: widget.moreOnRowButton ??
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.black38.withOpacity(.8),
                            shape: BoxShape.circle),
                        child: const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
