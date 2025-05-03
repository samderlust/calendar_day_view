import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverflowDayView Tests', () {
    final events = [
      DayEvent<String>(
        start: DateTime(2024, 1, 1, 9, 0),
        end: DateTime(2024, 1, 1, 10, 0),
        value: 'Test Event 1',
      ),
      DayEvent<String>(
        start: DateTime(2024, 1, 1, 9, 30),
        end: DateTime(2024, 1, 1, 10, 30),
        value: 'Test Event 2',
      ),
    ];

    testWidgets('renders OverflowDayView correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarDayViewFactory.overflow(
          config: OverFlowDayViewConfig(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: events,
          overflowItemBuilder: (context, constraints, itemIndex, event) {
            return Container(
              constraints: constraints,
              color: Colors.blue,
              child: Text(event.value),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(OverFlowCalendarDayView<String>), findsOneWidget);
      expect(find.text('Test Event 1'), findsOneWidget);
      expect(find.text('Test Event 2'), findsOneWidget);
    });

    testWidgets('handles overlapping events', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarDayViewFactory.overflow(
          config: OverFlowDayViewConfig(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: events,
          overflowItemBuilder: (context, constraints, itemIndex, event) {
            return Container(
              constraints: constraints,
              color: Colors.blue,
              child: Text(event.value),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      // Both events should be visible
      expect(find.text('Test Event 1'), findsOneWidget);
      expect(find.text('Test Event 2'), findsOneWidget);
    });
  });
}
