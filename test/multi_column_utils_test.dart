import 'package:calendar_day_view/calendar_day_view.dart';
import 'package:calendar_day_view/src/utils/multi_column_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('assignColumns', () {
    test('returns empty list for empty input', () {
      final result = assignColumns<String>([]);
      expect(result, isEmpty);
    });

    test('single event gets column 0, totalColumns 1', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 10, 0), value: 'A'),
      ];
      final result = assignColumns(events);
      expect(result.length, 1);
      expect(result[0].column, 0);
      expect(result[0].totalColumns, 1);
    });

    test('non-overlapping events each get column 0, totalColumns 1', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 10, 0), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 11, 0), end: DateTime(2024, 1, 1, 12, 0), value: 'B'),
      ];
      final result = assignColumns(events);
      expect(result.length, 2);
      expect(result[0].column, 0);
      expect(result[0].totalColumns, 1);
      expect(result[1].column, 0);
      expect(result[1].totalColumns, 1);
    });

    test('two overlapping events get columns 0 and 1, totalColumns 2', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 10, 0), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 30), end: DateTime(2024, 1, 1, 10, 30), value: 'B'),
      ];
      final result = assignColumns(events);
      expect(result.length, 2);
      expect(result[0].column, 0);
      expect(result[0].totalColumns, 2);
      expect(result[1].column, 1);
      expect(result[1].totalColumns, 2);
    });

    test('three-way overlap gets 3 columns', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 10, 0), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 15), end: DateTime(2024, 1, 1, 10, 15), value: 'B'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 30), end: DateTime(2024, 1, 1, 10, 30), value: 'C'),
      ];
      final result = assignColumns(events);
      expect(result.length, 3);
      for (final ce in result) {
        expect(ce.totalColumns, 3);
      }
      expect(result.map((e) => e.column).toSet(), {0, 1, 2});
    });

    test('transitive overlap: A overlaps B, B overlaps C, A does not overlap C', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 9, 30), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 15), end: DateTime(2024, 1, 1, 10, 0), value: 'B'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 45), end: DateTime(2024, 1, 1, 10, 30), value: 'C'),
      ];
      final result = assignColumns(events);
      expect(result.length, 3);
      // A and B overlap -> columns 0, 1
      // B and C overlap -> C reuses column 0 (A has ended)
      // All in same cluster -> totalColumns = 2
      expect(result[0].column, 0); // A
      expect(result[1].column, 1); // B
      expect(result[2].column, 0); // C (reuses A's column)
      for (final ce in result) {
        expect(ce.totalColumns, 2);
      }
    });

    test('column reuse after gap', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 9, 30), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 9, 30), value: 'B'),
        // gap
        DayEvent<String>(start: DateTime(2024, 1, 1, 11, 0), end: DateTime(2024, 1, 1, 11, 30), value: 'C'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 11, 0), end: DateTime(2024, 1, 1, 11, 30), value: 'D'),
      ];
      final result = assignColumns(events);
      expect(result.length, 4);
      // First cluster
      expect(result[0].totalColumns, 2);
      expect(result[1].totalColumns, 2);
      // Second cluster (separate)
      expect(result[2].totalColumns, 2);
      expect(result[3].totalColumns, 2);
    });

    test('events without end time default to 30 min', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 15), value: 'B'),
      ];
      final result = assignColumns(events);
      expect(result.length, 2);
      expect(result[0].totalColumns, 2); // they overlap (9:00-9:30 vs 9:15-9:45)
    });

    test('events exactly adjacent do not overlap', () {
      final events = [
        DayEvent<String>(start: DateTime(2024, 1, 1, 9, 0), end: DateTime(2024, 1, 1, 10, 0), value: 'A'),
        DayEvent<String>(start: DateTime(2024, 1, 1, 10, 0), end: DateTime(2024, 1, 1, 11, 0), value: 'B'),
      ];
      final result = assignColumns(events);
      expect(result.length, 2);
      expect(result[0].column, 0);
      expect(result[0].totalColumns, 1);
      expect(result[1].column, 0);
      expect(result[1].totalColumns, 1);
    });
  });
}
