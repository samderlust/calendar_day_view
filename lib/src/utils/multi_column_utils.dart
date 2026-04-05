import 'dart:math';

import '../../calendar_day_view.dart';

/// Default duration in minutes for events with a null `end`.
const _defaultDurationMinutes = 30;

/// Assigns events to columns for a multi-column overlap layout.
///
/// This is the default implementation used by [MultiColumnCalendarDayView].
/// It runs a two-phase algorithm:
///
/// 1. **Greedy column assignment.** Events are sorted by start time (with
///    longer events winning ties) and assigned to the lowest-indexed
///    column whose previously-assigned event has already ended.
/// 2. **Cluster grouping.** Transitively-overlapping events are grouped
///    into clusters so they all share the same [ColumnEvent.totalColumns]
///    value, producing uniform widths within each cluster.
///
/// Events outside `[startOfDay, endOfDay]` are filtered out. Events with a
/// null [DayEvent.end] are treated as 30 minutes long.
///
/// This function is the default behavior when
/// [MultiColumnDayViewConfig.overlapStrategy] is null — provide a custom
/// [OverlapStrategy] to replace it.
List<ColumnEvent<T>> assignColumns<T extends Object>(
  List<DayEvent<T>> events, {
  DateTime? startOfDay,
  DateTime? endOfDay,
}) {
  if (events.isEmpty) return [];

  // Sort: by start ascending, then by duration descending (longer events get earlier columns)
  final sorted = [...events]..sort((a, b) {
      final cmp = a.start.compareTo(b.start);
      if (cmp != 0) return cmp;
      return b.durationInMins.compareTo(a.durationInMins);
    });

  // Filter to day range if provided
  final filtered = (startOfDay != null && endOfDay != null)
      ? sorted.where((e) => !e.start.isBefore(startOfDay) && !e.start.isAfter(endOfDay)).toList()
      : sorted;

  if (filtered.isEmpty) return [];

  DateTime resolveEnd(DayEvent<T> e) => e.end ?? e.start.add(const Duration(minutes: _defaultDurationMinutes));

  // Phase 1: Greedy column assignment
  final List<DateTime> columnEnds = [];
  final List<int> columnAssignments = [];

  for (final event in filtered) {
    int assignedCol = -1;
    for (int c = 0; c < columnEnds.length; c++) {
      if (!columnEnds[c].isAfter(event.start)) {
        assignedCol = c;
        break;
      }
    }
    if (assignedCol == -1) {
      assignedCol = columnEnds.length;
      columnEnds.add(resolveEnd(event));
    } else {
      columnEnds[assignedCol] = resolveEnd(event);
    }
    columnAssignments.add(assignedCol);
  }

  // Phase 2: Group into connected overlap clusters, assign totalColumns
  final result = <ColumnEvent<T>>[];
  int clusterStart = 0;
  DateTime clusterEnd = resolveEnd(filtered[0]);

  for (int i = 1; i <= filtered.length; i++) {
    if (i == filtered.length || !filtered[i].start.isBefore(clusterEnd)) {
      // Finalize cluster [clusterStart, i)
      int maxCol = 0;
      for (int j = clusterStart; j < i; j++) {
        maxCol = max(maxCol, columnAssignments[j]);
      }
      final totalCols = maxCol + 1;
      for (int j = clusterStart; j < i; j++) {
        result.add(ColumnEvent(
          event: filtered[j],
          column: columnAssignments[j],
          totalColumns: totalCols,
        ));
      }
      if (i < filtered.length) {
        clusterStart = i;
        clusterEnd = resolveEnd(filtered[i]);
      }
    } else {
      final end = resolveEnd(filtered[i]);
      if (end.isAfter(clusterEnd)) clusterEnd = end;
    }
  }

  return result;
}
