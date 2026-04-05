import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MultiColumnCalendarDayView Tests', () {
    final overlappingEvents = [
      DayEvent<String>(
        start: DateTime(2024, 1, 1, 9, 0),
        end: DateTime(2024, 1, 1, 10, 0),
        value: 'Event A',
      ),
      DayEvent<String>(
        start: DateTime(2024, 1, 1, 9, 30),
        end: DateTime(2024, 1, 1, 10, 30),
        value: 'Event B',
      ),
    ];

    testWidgets('renders correctly with basic configuration', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView.multiColumn<String>(
          config: MultiColumnDayViewConfig<String>(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: overlappingEvents,
          itemBuilder: (context, constraints, event, colIndex, totalCols) {
            return Container(
              constraints: constraints,
              color: Colors.blue,
              child: Text(event.value),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(MultiColumnCalendarDayView<String>), findsOneWidget);
      expect(find.text('Event A'), findsOneWidget);
      expect(find.text('Event B'), findsOneWidget);
    });

    testWidgets('handles empty events list', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView.multiColumn<String>(
          config: MultiColumnDayViewConfig<String>(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: <DayEvent<String>>[],
          itemBuilder: (context, constraints, event, colIndex, totalCols) {
            return Text(event.value);
          },
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(MultiColumnCalendarDayView<String>), findsOneWidget);
      expect(find.text('Event A'), findsNothing);
    });

    testWidgets('handles onTimeTap callback', (tester) async {
      DateTime? tappedTime;

      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView.multiColumn<String>(
          config: MultiColumnDayViewConfig<String>(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: overlappingEvents,
          onTimeTap: (time) {
            tappedTime = time;
          },
          itemBuilder: (context, constraints, event, colIndex, totalCols) {
            return Container(
              constraints: constraints,
              color: Colors.blue,
              child: Text(event.value),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      expect(tappedTime, isNotNull);
    });

    testWidgets('provides column info to item builder', (tester) async {
      final columnInfos = <MapEntry<int, int>>[];

      await tester.pumpWidget(MaterialApp(
        home: CalendarDayView.multiColumn<String>(
          config: MultiColumnDayViewConfig<String>(
            currentDate: DateTime(2024, 1, 1),
            timeGap: 60,
            heightPerMin: 1,
          ),
          events: overlappingEvents,
          itemBuilder: (context, constraints, event, colIndex, totalCols) {
            columnInfos.add(MapEntry(colIndex, totalCols));
            return Container(
              constraints: constraints,
              color: Colors.blue,
              child: Text(event.value),
            );
          },
        ),
      ));

      await tester.pumpAndSettle();

      // Two overlapping events should get totalColumns = 2
      expect(columnInfos.length, 2);
      expect(columnInfos[0].value, 2); // totalColumns
      expect(columnInfos[1].value, 2);
      expect(columnInfos[0].key, 0); // column 0
      expect(columnInfos[1].key, 1); // column 1
    });
  });
}
