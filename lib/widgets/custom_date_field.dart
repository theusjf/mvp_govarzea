import 'package:flutter/material.dart';

class CustomDateField extends StatefulWidget {
  final String labelText;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final void Function(DateTime?)? onDateChanged;
  final String? Function(DateTime?)? validator;

  const CustomDateField({
    super.key,
    required this.labelText,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateChanged,
    this.validator,
  });

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime(2000),
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
          );
          if (picked != null) {
            setState(() {
              _selectedDate = picked;
            });
            if (widget.onDateChanged != null) {
              widget.onDateChanged!(picked);
            }
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            validator: (value) {
              if (widget.validator != null) {
                return widget.validator!(_selectedDate);
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: 'Selecionar data',
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
            controller: TextEditingController(
              text: _selectedDate == null ? '' : _formatDate(_selectedDate!),
            ),
            readOnly: true,
          ),
        ),
      ),
    );
  }
}
