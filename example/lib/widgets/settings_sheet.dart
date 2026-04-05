import 'package:flutter/material.dart';

/// Opens a settings bottom sheet with the given option widgets.
///
/// [buildOptions] is called with a [StateSetter] that rebuilds the modal when
/// an option's value changes. Use it in your `onChanged` callbacks:
///
/// ```dart
/// showSettingsSheet(
///   context: context,
///   title: '...',
///   buildOptions: (setState) => [
///     SwitchSetting(
///       value: myFlag.value,
///       onChanged: (v) => setState(() => myFlag.value = v),
///     ),
///   ],
/// );
/// ```
Future<void> showSettingsSheet({
  required BuildContext context,
  required String title,
  required List<Widget> Function(StateSetter setState) buildOptions,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.3,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: buildOptions(setState),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}

/// A labeled row containing a settings option widget.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

/// A settings row with a toggle switch.
class SwitchSetting extends StatelessWidget {
  const SwitchSetting({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}

/// A settings row with a segmented button to pick one value from a list.
class SegmentSetting<T> extends StatelessWidget {
  const SegmentSetting({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.labels,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> options;
  final List<String> labels;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingRow(
      label: label,
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<T>(
          segments: [
            for (var i = 0; i < options.length; i++)
              ButtonSegment(value: options[i], label: Text(labels[i])),
          ],
          selected: {value},
          onSelectionChanged: (v) => onChanged(v.first),
        ),
      ),
    );
  }
}
