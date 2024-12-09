import 'package:calendar_day_view/src/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../calendar_day_view.dart';
import '../../../models/typedef.dart';
import '../../dav_view_config.dart';

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
                        switch (event) {
                          var event? => Container(
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
                          _ => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: (onTileTap == null)
                                  ? null
                                  : () => onTileTap!(category, time),
                              child: SizedBox(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                              ),
                            )
                        },
                        // if (event == null) const SizedBox.shrink(),
                        // if (event != null)
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
    required this.categories,
    required this.rowEvents,
    required this.onTileTap,
    required this.tileWidth,
    required this.config,
    required this.eventBuilder,
  });

  final CategoryDavViewConfig config;
  final DateTime time;
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<T>> rowEvents;
  final CategoryDayViewTileTap<T>? onTileTap;
  final double tileWidth;
  final CategoryDayViewEventBuilder<T> eventBuilder;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ...categories
              .map((category) {
                final event = rowEvents
                    .firstWhereOrNull((e) => e.categoryId == category.id);

                final constraints = BoxConstraints(
                    maxHeight: config.rowHeight, maxWidth: tileWidth);
                return [
                  switch (event) {
                    var event? => ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: tileWidth,
                          minHeight: config.rowHeight,
                        ),
                        child: eventBuilder(
                          constraints,
                          category,
                          time,
                          event,
                        ),
                      ),
                    _ => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: (onTileTap == null)
                            ? null
                            : () => onTileTap!(category, time),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                        ),
                      ),
                  },
                  config.verticalDivider ?? const VerticalDivider(width: 0),
                ];
              })
              .expand((element) => element)
              .toList()
        ],
      ),
    );
  }
}
