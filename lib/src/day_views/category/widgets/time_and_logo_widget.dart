import 'package:flutter/material.dart';

import '../../../extensions/date_time_extension.dart';
import '../../day_view_config.dart';

class TimeAndLogoWidget extends StatelessWidget {
  const TimeAndLogoWidget({
    super.key,
    required this.config,
  });

  final CategoryDavViewConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: config.timeColumnWidth,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: config.timeColumnWidth,
                    minWidth: config.timeColumnWidth,
                    minHeight: config.rowHeight,
                  ),
                  child: config.logo ??
                      Container(
                        decoration: config.headerDecoration,
                      ),
                ),
                config.verticalDivider ?? const VerticalDivider(width: 0),
              ],
            ),
          ),
          config.horizontalDivider ?? const Divider(height: 0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: config.timeList.length,
            separatorBuilder: (context, index) =>
                config.horizontalDivider ?? const Divider(height: 0),
            itemBuilder: (context, index) {
              final time = config.timeList.elementAt(index);

              return IntrinsicHeight(
                key: ValueKey(time),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? config.evenRowColor
                              : config.oddRowColor,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: config.rowHeight,
                          minHeight: config.rowHeight,
                        ),
                        child: SizedBox(
                          width: config.timeColumnWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: config.timeLabelBuilder?.call(
                                  context,
                                  time,
                                ) ??
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    config.time12
                                        ? time.hourDisplay12
                                        : time.hourDisplay24,
                                    style: config.timeTextStyle,
                                    maxLines: 1,
                                  ),
                                ),
                          ),
                        )),
                    config.verticalDivider ?? const VerticalDivider(width: 0),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
