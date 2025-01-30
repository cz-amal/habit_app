import 'package:flutter/material.dart';
class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const InputField({super.key, required this.controller, required this.hint});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle:
        TextStyle(color: Colors.grey[600]), // Hint text color
        filled: true,
        fillColor: Colors.grey[800], // Background color
        hoverColor: Colors.grey[300], // Hover color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: const BorderSide(
            color: Colors.grey, // Default border color
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.white, // Border color when focused
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: const TextStyle(color: Colors.white), // Text color
    );
  }
}
