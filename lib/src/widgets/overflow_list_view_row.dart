import 'package:flutter/material.dart';

import '../../calendar_day_view.dart';
import '../overflow_event.dart';
import '../time_of_day_extension.dart';

class OverflowListViewRow<T extends Object> extends StatelessWidget {
  const OverflowListViewRow({
    Key? key,
    required this.oEvents,
    required this.overflowItemBuilder,
    required this.heightUnit,
    required this.eventColumnWith,
  }) : super(key: key);

  final OverflowEventsRow<T> oEvents;
  final OverflowItemBuilder<T> overflowItemBuilder;
  final double heightUnit;
  final double eventColumnWith;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: eventColumnWith,
      height: heightUnit * oEvents.start.minuteUntil(oEvents.end),
      constraints: BoxConstraints(
        maxHeight: heightUnit * oEvents.start.minuteUntil(oEvents.end),
        minHeight: heightUnit * oEvents.start.minuteUntil(oEvents.end),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: oEvents.events.length,
        itemBuilder: (context, index) {
          final event = oEvents.events.elementAt(index);
          final width = eventColumnWith / oEvents.events.length;
          return Column(
            children: [
              SizedBox(
                height: event.start.minuteFrom(oEvents.start) * heightUnit,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: event.durationInMins * heightUnit,
                ),
                child: overflowItemBuilder(
                  context,
                  BoxConstraints(
                    maxHeight: event.durationInMins * heightUnit,
                    minHeight: event.durationInMins * heightUnit,
                    minWidth: width,
                    maxWidth: eventColumnWith,
                  ),
                  event,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
