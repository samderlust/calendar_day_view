
extension ListX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    final l = where(test);
    if (l.isNotEmpty) {
      return l.first;
    }
    return null;
  }
}
