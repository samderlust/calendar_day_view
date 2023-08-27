import 'package:flutter/material.dart';

class TimeAndLogoWidget extends StatelessWidget {
  const TimeAndLogoWidget({
    super.key,
    required this.rowHeight,
    required this.timeColumnWidth,
    this.logo,
    this.headerDecoration,
    this.verticalDivider,
    this.horizontalDivider,
    required this.timeList,
    required this.evenRowColor,
    required this.oddRowColor,
    this.timeTextStyle,
  });

  final double rowHeight;
  final double timeColumnWidth;
  final Widget? logo;
  final BoxDecoration? headerDecoration;
  final VerticalDivider? verticalDivider;
  final Divider? horizontalDivider;
  final List<DateTime> timeList;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final TextStyle? timeTextStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: timeColumnWidth,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: timeColumnWidth,
                    minWidth: timeColumnWidth,
                    minHeight: rowHeight,
                  ),
                  child: logo ??
                      Container(
                        decoration: headerDecoration,
                      ),
                ),
                verticalDivider ?? const VerticalDivider(width: 0),
              ],
            ),
          ),
          horizontalDivider ?? const Divider(height: 0),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeList.length,
            separatorBuilder: (context, index) =>
                horizontalDivider ?? const Divider(height: 0),
            itemBuilder: (context, index) {
              final time = timeList.elementAt(index);

              return IntrinsicHeight(
                key: ValueKey(time),
                child: Row(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? evenRowColor : oddRowColor,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: rowHeight,
                          minHeight: rowHeight,
                        ),
                        child: SizedBox(
                          width: timeColumnWidth,
                          child: Center(
                            child: Text(
                              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, "0")}",
                              style: timeTextStyle,
                            ),
                          ),
                        )),
                    verticalDivider ?? const VerticalDivider(width: 0),
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
