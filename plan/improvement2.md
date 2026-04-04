# Feature / Usage Improvements

### 1. Auto-scroll to current time on load
- Overflow and in-row views start at the top of the day (7am default)
- Users have to manually scroll to "now"
- Add an option (e.g., `scrollToCurrentTime: true`) to auto-scroll on initial render

### 2. Custom current time line builder
- `CurrentTimeLineWidget` is hard-coded (red circle at left:40, line at indent:45)
- Only color is customizable
- Add a `currentTimeLineBuilder` callback to allow full customization

### 3. Multiple events per category cell are silently dropped
- `_buildEventCell` uses `firstOrNull` — only the first event per category+timeslot is shown
- If two events exist in the same cell, the second is invisible with no indication
- Add a property (e.g., `showAllEventsInCell`) to toggle between showing only the first event or showing all events in the cell horizontally

### 4. Null `end` crashes overflow views
- `processOverflowEvents` force-unwraps `event.end!`
- `DayEvent.end` is nullable, so passing events without end time causes a runtime crash
- Should handle gracefully (e.g., default duration like `durationInMins` does) or validate with a clear error

### 5. Empty tile builder for category views
- Empty category cells render a plain `SizedBox`
- Add an `emptyTileBuilder` callback so users can customize empty cells (e.g., "available" label, background patterns)

### 6. Improve example UI
- Modernize the example app UI

### 7. Clean project problems
- Fix lint warnings and deprecations flagged by analyzer

### 8. Inconsistent tap callback naming across views
- Overflow: `onTimeTap`
- InRow: `onTap`
- Category: `onTileTap`
- Standardizing would make the API easier to learn
- Breaking change — defer to major version
