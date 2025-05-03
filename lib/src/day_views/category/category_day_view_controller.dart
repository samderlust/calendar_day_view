import 'package:flutter/material.dart';

class CategoryDayViewController {
  CategoryDayViewController({
    ScrollController? horizontalScrollController,
    ScrollController? verticalScrollController,
  })  : horizontalScrollController = horizontalScrollController ?? ScrollController(),
        verticalScrollController = verticalScrollController ?? ScrollController();

  final ScrollController horizontalScrollController;
  final ScrollController verticalScrollController;

  double _tabLength = 0;
  double _columnWidth = 0;

  void dispose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
  }

  void calbliate(double columnLength, int columnsPerPage) {
    _columnWidth = columnLength;
    _tabLength = columnLength * columnsPerPage;
  }

  void goToPreviousTab() {
    final currentTabLength = _tabLength;
    final newIndex = horizontalScrollController.offset - currentTabLength;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void goToNextTab() {
    final currentTabLength = _tabLength;
    final newIndex = horizontalScrollController.offset + currentTabLength;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void goToColumn(int index) {
    final newIndex = index * _columnWidth;
    horizontalScrollController.animateTo(newIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
