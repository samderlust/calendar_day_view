import 'package:flutter/material.dart';

import '../extensions/time_of_day_extension.dart';
import '../models/day_event.dart';
import '../models/overflow_event.dart';
import '../models/typedef.dart';
import 'background_ignore_pointer.dart';

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
  }) : super(key: key);

  final OverflowEventsRow<T> oEvents;
  final DayViewItemBuilder<T> overflowItemBuilder;
  final double heightUnit;
  final double eventColumnWith;
  final double totalHeight;
  final Widget? moreOnRowButton;
  final bool showMoreOnRowButton;
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
        // clipBehavior: Clip.none,
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
              final tileHeight = (maxHeight < (topGap + tilePossibleHeight))
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
                  SizedBox(
                    height: topGap,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: tileHeight),
                    child: StopBackgroundIgnorePointer(
                      ignored: widget.ignored,
                      child: widget.overflowItemBuilder(
                        context,
                        tileConstraints,
                        index,
                        event,
                      ),
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
