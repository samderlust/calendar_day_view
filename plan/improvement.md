# Improvement Plan

## Now

### 1. Remove unused typedefs from `typedef.dart`

- `CategoryBackgroundTimeRowBuilder` — only in its definition
- `CategoryDayViewRowBuilder` — only in its definition
- `OverflowEventsSorter` — only in its definition
- `CategoryDayViewHeaderTileBuilder` — only referenced in a comment

### 2. Remove commented-out `headerTileBuilder` in `CategoryDavViewConfig`

- Line 83 of `day_view_config.dart` — `// final CategoryDayViewHeaderTileBuilder? headerTileBuilder;`

### 3. Unused factory params in `calendar_day_view_base.dart`

- `CalendarDayView.category()` accepts `controlBarBuilder` but never passes it to the view
- `CalendarDayView.categoryOverflow()` accepts `controlBarBuilder` and `backgroundTimeTileBuilder` but never passes them to the view
- Either wire them up or remove from the factory -> wire them.

## Future (breaking changes — defer to major version)

### 4. Test coverage

- No tests for `EventCalendarDayView` (eventOnly)
- No tests for `CategoryOverflowDayView`
- No tests for utility functions (`processOverflowEvents`, `getTimeList`)
- No tests for extension methods (`DateTimeExtension`, `DayEventExtension`)

### 5. Rename `DavViewConfig` → `DayViewConfig`

- "Dav" is likely a typo for "Day"
- Public API — breaking change
