import 'package:flutter/material.dart';

import '../../../../calendar_day_view.dart';
import '../../day_view_config.dart';

class CategoryTitleRow extends StatelessWidget {
  const CategoryTitleRow({
    super.key,
    required this.config,
    required this.categories,
    required this.tileWidth,
  });

  final CategoryDavViewConfig config;

  final List<EventCategory> categories;
  final double tileWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: config.headerDecoration,
      constraints: BoxConstraints(minHeight: config.rowHeight),
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (config.stickyCategories)
              IntrinsicHeight(
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: config.timeColumnWidth,
                        minWidth: config.timeColumnWidth,
                        minHeight: config.rowHeight,
                      ),
                      child:
                          config.logo ??
                          Container(decoration: config.headerDecoration),
                    ),
                    config.verticalDivider ?? const VerticalDivider(width: 0),
                  ],
                ),
              ),
            ...categories
                .map(
                  (category) => [
                    SizedBox(
                      width: tileWidth,
                      height: config.rowHeight,
                      child: Center(
                        child: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    config.verticalDivider ?? const VerticalDivider(width: 0),
                  ],
                )
                .expand((e) => e)
                .toList(),
          ],
        ),
      ),
    );
  }
}
