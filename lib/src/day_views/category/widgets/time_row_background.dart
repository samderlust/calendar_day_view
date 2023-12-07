import 'package:flutter/material.dart';

class TimeRowBackground extends StatelessWidget {
  const TimeRowBackground({
    super.key,
    required this.rowNumber,
    required this.evenRowColor,
    required this.oddRowColor,
    required this.rowHeight,
    required this.timeList,
    this.rowBuilder,
  });

  final int rowNumber;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final double rowHeight;
  final List<DateTime> timeList;
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    DateTime rowTime,
    bool isOdd,
  )? rowBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timeList.length,
      itemBuilder: (context, index) {
        final time = timeList.elementAt(index);

//TODO: check if that tile has event on top
        return Container(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? evenRowColor : oddRowColor,
          ),
          constraints: BoxConstraints(minHeight: rowHeight),
          child: rowBuilder!(
            context,
            BoxConstraints(minHeight: rowHeight),
            time,
            index % 2 != 0,
          ),
        );
      },
    );
  }
}
