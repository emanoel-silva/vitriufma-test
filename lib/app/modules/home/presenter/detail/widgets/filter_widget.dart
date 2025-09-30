import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';

class FilterSection extends StatelessWidget {
  final List<FilterItem> filters;
  final Function(String, dynamic) onFilterChanged;

  const FilterSection({
    Key? key,
    required this.filters,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Largura ajustável conforme necessário.
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filters.map((filter) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                filter.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              filter.buildFilterWidget(onFilterChanged),
              const Divider(),
            ],
          );
        }).toList(),
      ),
    );
  }
}

abstract class FilterItem {
  final String label;

  FilterItem({required this.label});

  Widget buildFilterWidget(Function(String, dynamic) onFilterChanged);
}

class DropdownFilter extends FilterItem {
  final List<String> options;
  final String selectedOption;

  DropdownFilter({
    required String label,
    required this.options,
    required this.selectedOption,
  }) : super(label: label);

  @override
  Widget buildFilterWidget(Function(String, dynamic) onFilterChanged) {
    final uniqueOptions = options.toSet().toList(); // Remove duplicatas.

    return DropdownButton<String>(
      value: uniqueOptions.contains(selectedOption) ? selectedOption : null,
      onChanged: (value) {
        if (value != null) {
          onFilterChanged(label, value);
        }
      },
      items: uniqueOptions
          .map((option) => DropdownMenuItem(
                value: option,
                child: Text(option),
              ))
          .toList(),
    );
  }
}

class StarFilter extends FilterItem {
  final int selectedStars;

  StarFilter({
    required String label,
    required this.selectedStars,
  }) : super(label: label);

  @override
  Widget buildFilterWidget(Function(String, dynamic) onFilterChanged) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < selectedStars ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () {
            onFilterChanged(label, index + 1);
          },
        );
      }),
    );
  }
}

class CheckboxFilter extends FilterItem {
  final bool isChecked;
  final String value;

  CheckboxFilter({
    required String label,
    required this.value,
    required this.isChecked,
  }) : super(label: label);

  @override
  Widget buildFilterWidget(Function(String, dynamic) onFilterChanged) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (value) {
            if (value != null) {
              onFilterChanged(label, value);
            }
          },
        ),
        AppText(text: value, fontSize: 16),
      ],
    );
  }
}
