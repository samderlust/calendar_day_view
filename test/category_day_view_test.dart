import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryDayView Tests', () {
    final categories = [
      EventCategory(id: '1', name: 'Category 1'),
      EventCategory(id: '2', name: 'Category 2'),
    ];

    final events = [
      CategorizedDayEvent<String>(
        categoryId: '1',
        start: DateTime(2024, 1, 1, 9, 1),
        end: DateTime(2024, 1, 1, 10, 0),
        value: 'Test Event 1',
      ),
      CategorizedDayEvent<String>(
        categoryId: '2',
        start: DateTime(2024, 1, 1, 11, 0),
        end: DateTime(2024, 1, 1, 12, 0),
        value: 'Test Event 2',
      ),
    ];

    testWidgets('renders CategoryDayView correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView<String>.category(
          config: CategoryDavViewConfig(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          categories: categories,
          events: events,
          eventBuilder: (constraints, category, time, event) => Container(
            constraints: constraints,
            child: Text(event.value),
          ),
        ),
      ));

      expect(find.byType(CategoryCalendarDayView<String>), findsOneWidget);
      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Test Event 1'), findsOneWidget);
    });

    testWidgets('handles onTileTap callback', (tester) async {
      EventCategory? tappedCategory;
      DateTime? tappedTime;

      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView<String>.category(
          config: CategoryDavViewConfig(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          categories: categories,
          events: events,
          onTileTap: (category, time) {
            tappedCategory = category;
            tappedTime = time;
          },
          eventBuilder: (context, constraints, itemIndex, event) =>
              Text(event.value),
        ),
      ));

      // Find and tap an empty tile
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(tappedCategory, isNotNull);
      expect(tappedTime, isNotNull);
    });
  });
}
