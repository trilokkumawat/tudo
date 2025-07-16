import 'package:flutter/material.dart';
import 'package:todo/components/custometext.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String? value;
  final void Function(String?)? onChanged;
  final String? label;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.label,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map(
            (opt) => DropdownMenuItem(
              value: opt,
              child: CustomeText(text: opt),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
