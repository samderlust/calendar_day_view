import 'package:flutter/material.dart';

import '../../../../calendar_day_view.dart';

class CategoryTitleRow extends StatelessWidget {
  const CategoryTitleRow({
    super.key,
    required this.rowHeight,
    required this.verticalDivider,
    required this.categories,
    required this.tileWidth,
    this.headerDecoration,
    required this.timeColumnWidth,
    this.logo,
  });

  final double rowHeight;
  final VerticalDivider? verticalDivider;
  final List<EventCategory> categories;
  final double tileWidth;
  final BoxDecoration? headerDecoration;
  final Widget? logo;
  final double timeColumnWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: headerDecoration,
      constraints: BoxConstraints(minHeight: rowHeight),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...categories
                .map(
                  (category) => [
                    SizedBox(
                      width: tileWidth,
                      height: rowHeight,
                      child: Center(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    verticalDivider ?? const VerticalDivider(width: 0),
                  ],
                )
                .expand((e) => e)
                .toList()
          ],
        ),
      ),
    );
  }
}
