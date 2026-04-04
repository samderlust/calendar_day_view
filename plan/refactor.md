# Refactor Plan

All functionalities kept the same. Focus on dead code removal, bug fixes, and code consolidation.

## High Priority

### 1. ~~Delete unused widget files (not imported anywhere)~~ DONE
- Deleted `time_and_logo_widget.dart`, `time_row_background.dart`, `category_title_row.dart`

### 2. ~~Delete commented-out code~~ DONE
- Cleaned `date_time_extension.dart` and `events_utils.dart`

### 3. ~~Fix `CategorizedDayEvent.operator==` bug~~ DONE
- Now compares all fields including parent class fields

## Medium Priority

### 4. ~~Consolidate `CategoryDayView` / `CategoryOverflowDayView` duplication~~ DONE
- Extracted shared `_CategoryTableView` widget, both views delegate to it with `overflow` flag
- Deleted `category_2d_overflow_day_view.dart`

### 5. ~~Remove `DayViewProvider`/`DayViewState` and `day_view_row.dart` (dead code)~~ DONE
- `DayViewProvider` was never imported by any view — deleted entirely
- `day_view_row.dart` was never imported — deleted

### 6. ~~Inline `earlierThan`/`laterThan` extension wrappers~~ DONE
- Replaced with direct `isBefore`/`isAfter` calls in `events_utils.dart`
- Removed the extension methods

### 7. ~~Add `mounted` check in timer callbacks~~ DONE
- Added guard in `OverFlowCalendarDayView` and `InRowCalendarDayView`

## Low Priority

### 8. ~~Unify `DayViewRow` / `OverflowDayViewRow`~~ DONE
- Both were dead code (never imported) — deleted with item 5

### 9. ~~Replace custom `firstWhereOrNull` with Dart 3 built-in~~ DONE
- Replaced with `.where(...).firstOrNull`
- Deleted `list_extensions.dart`

### 10. ~~Fix `DayViewProvider.updateShouldNotify`~~ DONE
- Entire file was dead code — deleted with item 5

### 11. Naming inconsistency: `DavViewConfig` — DEFERRED
- "Dav" likely a typo for "Day"
- Public API so renaming is a breaking change — defer to a major version bump

## Additional cleanup
- Removed unused `heightPerMin` field from `OverFlowCalendarDayView` (duplicated in config)
- Removed commented-out asserts in `OverFlowCalendarDayView` constructor
- Removed empty `didUpdateWidget` override in `InRowCalendarDayView`
- Cleaned up empty `category/widgets/` directory
