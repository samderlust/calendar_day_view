# Feature Improvements

## New Day View

### ✅ Multi-Column Overlap View (like Google Calendar / Outlook) — DONE in v6.0.0
- The #1 missing view type
- When events overlap in time, auto-split into side-by-side columns within the same time area
- Auto-calculates how many columns are needed and sizes each event proportionally
- Current overflow view stacks overlapping events visually or renders as horizontal list
- Multi-column approach is what most users expect from a "real" calendar

```
|  9:00  | Meeting A  | Meeting B |
|        |            |           |
|  9:30  |            | Meeting B |
|        | Meeting C  |           |
| 10:00  |            |           |
```

## Customization Gaps

### ✅ 1. Time row background builder — DONE in v6.0.0
- Added `timeRowBackgroundBuilder` to base `DavViewConfig`
- Supported in overflow, multi-column, and in-row views
- Returns `Widget?` per row — return null to use default background
- Note: not wired into category views (TableView uses `SpanDecoration` which takes BoxDecoration, not widgets)

### ✅ 2. Divider builder — DONE in v6.0.0
- Added `dividerBuilder` to base `DavViewConfig`
- Returns `Widget?` per row — return null to skip the divider for that row
- Supported in overflow, multi-column, in-row, and event-only views
- Falls back to the default `Divider` if builder is not provided

### 3. Time column position
- Time column is always on the left
- Some designs put it on the right, or hide it entirely
- Add a `timeColumnPosition` enum (`left`, `right`, `none`)

### 4. Event positioning strategy for overlap view
- Currently the overlap algorithm is internal
- Users can't control how overlapping events are laid out (e.g., prefer wider events, stack vs split)
- Add an `overlapStrategy` callback for power users to define their own layout algorithm

### 5. Day view header/footer builder
- No way to add a header above the time grid (e.g., "Today - April 4" with weather) or a footer
- Add `headerBuilder`/`footerBuilder` on config for embedding views in richer layouts

### 6. Drag-to-create and drag-to-resize
- The #1 feature request for calendar packages
- `onDragCreate(startTime, endTime)` and `onEventResize(event, newEnd)` callbacks for interactive event management

## Priority

| Priority | Item | Status | Impact |
|----------|------|--------|--------|
| High | Multi-column overlap view | ✅ Done (v6.0.0) | Most requested missing view |
| High | Time row background builder | ✅ Done (v6.0.0) | Essential for real-world calendars |
| Medium | Divider builder | ✅ Done (v6.0.0) | Full visual control |
| Medium | Day view header/footer | | Embedability |
| Medium | Time column position | | Layout flexibility |
| Low | Overlap strategy callback | | Power user feature |
| Low | Drag-to-create/resize | | Complex but high value |
