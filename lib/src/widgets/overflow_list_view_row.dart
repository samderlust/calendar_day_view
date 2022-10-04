import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../overflow_event.dart';
import '../time_of_day_extension.dart';
import '../typedef.dart';

class OverflowListViewRow<T extends Object> extends StatefulWidget {
  const OverflowListViewRow({
    Key? key,
    required this.oEvents,
    required this.overflowItemBuilder,
    required this.heightUnit,
    required this.eventColumnWith,
    required this.showMoreOnRowButton,
    this.moreOnRowButton,
  }) : super(key: key);

  final OverflowEventsRow<T> oEvents;
  final DayViewItemBuilder<T> overflowItemBuilder;
  final double heightUnit;
  final double eventColumnWith;
  final Widget? moreOnRowButton;
  final bool showMoreOnRowButton;

  @override
  State<OverflowListViewRow<T>> createState() => _OverflowListViewRowState<T>();
}

class _OverflowListViewRowState<T extends Object>
    extends State<OverflowListViewRow<T>> {
  late ScrollController _scrollCtrl;
  bool _atEndOfList = false;

  @override
  void initState() {
    super.initState();
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
    final maxHeight = widget.heightUnit *
        widget.oEvents.start.minuteUntil(widget.oEvents.end);
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
              return Column(
                children: [
                  SizedBox(
                    height: event.start.minuteFrom(widget.oEvents.start) *
                        widget.heightUnit,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: event.durationInMins * widget.heightUnit,
                    ),
                    child: widget.overflowItemBuilder(
                      context,
                      BoxConstraints(
                        maxHeight: event.durationInMins * widget.heightUnit,
                        minHeight: event.durationInMins * widget.heightUnit,
                        minWidth: width,
                        maxWidth: widget.eventColumnWith,
                      ),
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
