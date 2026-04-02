import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:calendar_day_view/src/models/typedef.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

void main() {
  group('CategoryDayView Tests', () {
    late CategoryDavViewConfig config;
    late List<EventCategory> categories;
    late List<CategorizedDayEvent<String>> events;
    late CategoryDayViewEventBuilder<String> eventBuilder;
    late CategoryDayViewController controller;

    setUp(() {
      config = CategoryDavViewConfig(
        currentDate: DateTime(2024, 1, 1),
        time12: true,
        allowHorizontalScroll: true,
        columnsPerPage: 2,
        endOfDay: const TimeOfDay(hour: 23, minute: 59),
        timeColumnWidth: 100,
      );

      categories = [
        EventCategory(id: '1', name: 'Category 1'),
        EventCategory(id: '2', name: 'Category 2'),
        EventCategory(id: '3', name: 'Category 3'),
        EventCategory(id: '4', name: 'Category 4'),
        EventCategory(id: '5', name: 'Category 5'),
      ];

      events = [
        CategorizedDayEvent<String>(
          categoryId: '1',
          start: DateTime(2024, 1, 1, 10, 0),
          end: DateTime(2024, 1, 1, 11, 0),
          value: 'Event 1',
        ),
        CategorizedDayEvent<String>(
          categoryId: '2',
          start: DateTime(2024, 1, 1, 14, 0),
          end: DateTime(2024, 1, 1, 15, 0),
          value: 'Event 2',
        ),
      ];

      eventBuilder = (constraints, category, time, event) {
        return Container(
          color: Colors.blue,
          child: Center(
            child: Text(event.value),
          ),
        );
      };

      controller = CategoryDayViewController();
    });

    testWidgets('CategoryDayView renders correctly with basic configuration', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryDayView<String>(
              config: config,
              categories: categories,
              events: events,
              eventBuilder: eventBuilder,
              controller: controller,
              onTileTap: (_, __) {},
            ),
          ),
        ),
      );

      // Verify category titles are displayed
      expect(find.text('Category 1'), findsOneWidget);
      expect(find.text('Category 2'), findsOneWidget);
      expect(find.text('Category 3'), findsOneWidget);

      // Verify time column is present
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('CategoryDayView displays events in correct categories', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryDayView<String>(
              config: config,
              categories: categories,
              events: events,
              eventBuilder: eventBuilder,
              controller: controller,
              onTileTap: (_, __) {},
            ),
          ),
        ),
      );

      // Verify events are displayed in their respective categories
      expect(find.text('Event 1'), findsOneWidget);
      expect(find.text('Event 2'), findsOneWidget);
    });

    testWidgets('CategoryDayView handles empty events list', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryDayView<String>(
              config: config,
              categories: categories,
              events: [],
              eventBuilder: eventBuilder,
              controller: controller,
              onTileTap: (_, __) {},
            ),
          ),
        ),
      );

      // Verify no events are displayed
      expect(find.text('Event 1'), findsNothing);
      expect(find.text('Event 2'), findsNothing);
    });

    testWidgets('CategoryDayView handles onTileTap callback', (WidgetTester tester) async {
      bool tileTapped = false;
      EventCategory? tappedCategory;
      DateTime? tappedTime;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryDayView<String>(
              config: config,
              categories: categories,
              events: events,
              eventBuilder: eventBuilder,
              controller: controller,
              onTileTap: (category, time) {
                tileTapped = true;
                tappedCategory = category;
                tappedTime = time;
              },
            ),
          ),
        ),
      );

      // Tap on an empty tile
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(tileTapped, isTrue);
      expect(tappedCategory, isNotNull);
      expect(tappedTime, isNotNull);
    });
  });
}
