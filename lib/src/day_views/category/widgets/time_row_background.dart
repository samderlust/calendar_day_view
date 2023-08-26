import 'package:flutter/material.dart';

class TimeRowBackground extends StatelessWidget {
  const TimeRowBackground({
    super.key,
    required this.rowNumber,
    required this.evenRowColor,
    required this.oddRowColor,
    required this.rowHeight,
  });

  final int rowNumber;
  final Color? evenRowColor;
  final Color? oddRowColor;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rowNumber,
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
