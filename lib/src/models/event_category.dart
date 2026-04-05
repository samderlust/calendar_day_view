/// A category used by the category day views to group events into columns.
///
/// Each category has a unique [id] and a display [name]. Events reference
/// categories via [CategorizedDayEvent.categoryId].
///
/// Example:
/// ```dart
/// final rooms = [
///   EventCategory(id: 'room-1', name: 'Room 1'),
///   EventCategory(id: 'room-2', name: 'Room 2'),
/// ];
/// ```
class EventCategory {
  /// Unique identifier for the category. Must match
  /// [CategorizedDayEvent.categoryId] for events to appear in this column.
  final String id;

  /// Human-readable name shown in the category header.
  final String name;

  /// Creates a category with the given [id] and [name].
  EventCategory({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventCategory && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'EventCategory(id: $id, name: $name)';
}
