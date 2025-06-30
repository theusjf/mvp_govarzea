import 'package:flutter/material.dart';

class CustomDropdownField<Type> extends StatelessWidget {
  final String labelText;
  final Type? value;
  final List<Type> items;
  final String Function(Type) itemLabel;
  final void Function(Type?) onChanged;
  final String? Function(Type?)? validator;

  const CustomDropdownField({
    super.key,
    required this.labelText,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: DropdownButtonFormField<Type>(
        value: value,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: validator,
        icon: const Icon(Icons.arrow_drop_down),
        isExpanded: true,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        onChanged: onChanged,
        items: items.map((item) {
          return DropdownMenuItem<Type>(
            value: item,
            child: Text(itemLabel(item)),
          );
        }).toList(),
      ),
    );
  }
}
