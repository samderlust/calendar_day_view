import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InRowDayView Tests', () {
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

    testWidgets('renders InRowDayView correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView.inRow(
          config: InRowDayViewConfig(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: events,
          itemBuilder: (context, constraints, itemIndex, event) {
            return Container(
              constraints: constraints,
              color: Colors.blue,
              child: Text(event.value),
            );
          },
        ),
      ));

      expect(find.byType(InRowCalendarDayView<String>), findsOneWidget);
      expect(find.text('Test Event 1'), findsWidgets);
    });

    testWidgets('handles event tap callback', (tester) async {
      DayEvent? tappedEvent;

      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView.inRow(
          config: InRowDayViewConfig(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: events,
          itemBuilder: (context, constraints, itemIndex, event) {
            return GestureDetector(
              onTap: () {
                tappedEvent = event;
              },
              child: Container(
                constraints: constraints,
                color: Colors.blue,
                child: Text(event.value),
              ),
            );
          },
        ),
      ));

      await tester.tap(find.text('Test Event 1').first);
      await tester.pumpAndSettle();

      expect(tappedEvent, equals(events[0]));
    });
  });
}
