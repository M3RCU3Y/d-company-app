import 'package:flutter/material.dart';

class FilterChipRow extends StatelessWidget {
  const FilterChipRow({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return ChoiceChip(
            label: Text(option),
            selected: option == selected,
            onSelected: (_) => onSelected(option),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 10),
      ),
    );
  }
}
