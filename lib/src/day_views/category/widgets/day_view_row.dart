import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../calendar_day_view.dart';
import '../../../models/typedef.dart';

class OverflowDayViewRow<T extends Object> extends StatelessWidget {
  const OverflowDayViewRow({
    super.key,
    required this.heightPerMin,
    required this.time,
    required this.timeTextStyle,
    required this.horizontalDivider,
    required this.verticalDivider,
    required this.categories,
    required this.rowEvents,
    required this.onTileTap,
    required this.tileWidth,
    required this.rowHeight,
    required this.eventBuilder,
    required this.timeColumnWidth,
  });

  final double heightPerMin;
  final DateTime time;
  final TextStyle? timeTextStyle;
  final VerticalDivider? verticalDivider;
  final Divider? horizontalDivider;
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> rowEvents;
  final CategoryDayViewTileTap<T>? onTileTap;
  final double tileWidth;
  final double rowHeight;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final double timeColumnWidth;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: SizedBox(
        height: rowHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            //background
            Column(
              children: [
                SizedBox(height: rowHeight),
                horizontalDivider ?? const Divider(height: 0),
              ],
            ),
            //data
            Row(
              children: [
                ...categories
                    .map((category) {
                      final event = rowEvents
                          .firstWhereOrNull((e) => e.categoryId == category.id);

                      final eventHeight = switch (event) {
                        var e? => e.durationInMins,
                        _ => rowHeight,
                      }
                          .toDouble();

                      final topGap = switch (event) {
                        var e? => e.minutesFrom(time) * heightPerMin,
                        _ => 0.0,
                      }
                          .toDouble();
                      final constraints = BoxConstraints(
                        maxHeight: eventHeight,
                        maxWidth: tileWidth,
                      );

                      return [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (onTileTap == null || event != null)
                              ? null
                              : () => onTileTap!(category, time),
                          child: Container(
                            constraints: BoxConstraints(
                              minWidth: tileWidth,
                              maxWidth: tileWidth,
                              maxHeight: eventHeight + topGap,
                            ),
                            child: SizedBox(
                              height: eventHeight,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    top: topGap,
                                    child: eventBuilder(
                                      constraints,
                                      category,
                                      time,
                                      event,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        verticalDivider ?? const VerticalDivider(width: 0),
                      ];
                    })
                    .expand((element) => element)
                    .toList()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DayViewRow<T extends Object> extends StatelessWidget {
  const DayViewRow({
    super.key,
    required this.time,
    required this.timeTextStyle,
    required this.verticalDivider,
    required this.categories,
    required this.rowEvents,
    required this.onTileTap,
    required this.tileWidth,
    required this.rowHeight,
    required this.eventBuilder,
    required this.timeColumnWidth,
  });

  final DateTime time;
  final TextStyle? timeTextStyle;
  final VerticalDivider? verticalDivider;
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> rowEvents;
  final CategoryDayViewTileTap<T>? onTileTap;
  final double tileWidth;
  final double rowHeight;
  final CategoryDayViewEventBuilder<T> eventBuilder;
  final double timeColumnWidth;
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ...categories
              .map((category) {
                final event = rowEvents
                    .firstWhereOrNull((e) => e.categoryId == category.id);

                final constraints =
                    BoxConstraints(maxHeight: rowHeight, maxWidth: tileWidth);
                return [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: (onTileTap == null || event != null)
                        ? null
                        : () => onTileTap!(category, time),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: tileWidth,
                        minHeight: rowHeight,
                      ),
                      child: eventBuilder(
                        constraints,
                        category,
                        time,
                        event,
                      ),
                    ),
                  ),
                  verticalDivider ?? const VerticalDivider(width: 0),
                ];
              })
              .expand((element) => element)
              .toList()
        ],
      ),
    );
  }
}
