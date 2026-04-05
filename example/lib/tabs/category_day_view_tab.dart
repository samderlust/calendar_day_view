import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/settings_sheet.dart';

class CategoryDayViewTab extends HookWidget {
  const CategoryDayViewTab({
    super.key,
    required this.categories,
    required this.events,
    this.addEventOnClick,
  });
  final List<EventCategory> categories;
  final List<CategorizedDayEvent<String>> events;
  final Function(EventCategory, DateTime)? addEventOnClick;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final timeGap = useState<int>(60);
    final heightPerMin = useState<double>(1);
    final columnsPerPage = useState<int>(3);
    final allowHorizontalScroll = useState<bool>(false);
    final showAllEventsInCell = useState<bool>(false);
    final freezeCategoryTitleRow = useState<bool>(true);
    final time12 = useState<bool>(true);

    final controller = useMemoized(() => CategoryDayViewController(), []);

    return Scaffold(
      body: Column(
        children: [
          _CategoryTabControls(controller: controller),
          Expanded(
            child: CategoryDayView<String>(
              controller: controller,
              events: events,
              config: CategoryDavViewConfig(
                currentDate: DateTime.now(),
                time12: time12.value,
                timeGap: timeGap.value,
                heightPerMin: heightPerMin.value,
                columnsPerPage: columnsPerPage.value,
                allowHorizontalScroll: allowHorizontalScroll.value,
                showAllEventsInCell: showAllEventsInCell.value,
                freezeCategoryTitleRow: freezeCategoryTitleRow.value,
              ),
              categories: categories,
              onTimeTap: (category, time) {
                debugPrint('Category: $category  Time: $time');
                addEventOnClick?.call(category, time);
              },
              eventBuilder: (constraints, category, _, event) => GestureDetector(
                onTap: () => debugPrint('$event'),
                child: Container(
                  constraints: constraints,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  decoration: BoxDecoration(color: colorScheme.secondaryContainer),
                  child: Center(
                    child: Text(event.value.toString(), textAlign: TextAlign.center, overflow: TextOverflow.fade),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'category-settings',
        onPressed: () => showSettingsSheet(
          context: context,
          title: 'Category Day View Settings',
          buildOptions: (setSheetState) => [
            SegmentSetting<int>(
              label: 'Time Gap',
              value: timeGap.value,
              options: const [15, 30, 60],
              labels: const ['15m', '30m', '60m'],
              onChanged: (v) => setSheetState(() => timeGap.value = v),
            ),
            SegmentSetting<double>(
              label: 'Height Per Min',
              value: heightPerMin.value,
              options: const [0.5, 1.0, 1.5, 2.0],
              labels: const ['0.5x', '1x', '1.5x', '2x'],
              onChanged: (v) => setSheetState(() => heightPerMin.value = v),
            ),
            SegmentSetting<int>(
              label: 'Columns Per Page',
              value: columnsPerPage.value,
              options: const [2, 3, 4],
              labels: const ['2', '3', '4'],
              onChanged: (v) => setSheetState(() => columnsPerPage.value = v),
            ),
            SwitchSetting(
              label: 'Allow Horizontal Scroll',
              value: allowHorizontalScroll.value,
              onChanged: (v) => setSheetState(() => allowHorizontalScroll.value = v),
            ),
            SwitchSetting(
              label: 'Show All Events In Cell',
              value: showAllEventsInCell.value,
              onChanged: (v) => setSheetState(() => showAllEventsInCell.value = v),
            ),
            SwitchSetting(
              label: 'Freeze Category Title Row',
              value: freezeCategoryTitleRow.value,
              onChanged: (v) => setSheetState(() => freezeCategoryTitleRow.value = v),
            ),
            SwitchSetting(
              label: '12-hour format',
              value: time12.value,
              onChanged: (v) => setSheetState(() => time12.value = v),
            ),
          ],
        ),
        child: const Icon(Icons.tune),
      ),
    );
  }
}

class _CategoryTabControls extends StatelessWidget {
  const _CategoryTabControls({required this.controller});

  final CategoryDayViewController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Previous tab',
              onPressed: controller.goToPreviousTab,
              icon: const Icon(Icons.chevron_left),
            ),
            IconButton(
              tooltip: 'Next tab',
              onPressed: controller.goToNextTab,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
