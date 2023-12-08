import 'package:flutter/material.dart';

class TimeRowBackground extends StatelessWidget {
  const TimeRowBackground({
    super.key,
    required this.evenRowColor,
    required this.oddRowColor,
    required this.rowHeight,
    required this.timeList,
  });

  final double rowHeight;
  final List<DateTime> timeList;
  final Color? evenRowColor;
  final Color? oddRowColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: timeList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: index % 2 == 0 ? evenRowColor : oddRowColor,
          ),
          constraints: BoxConstraints(minHeight: rowHeight),
        );
      },
    );
  }
}
