import 'package:flutter/material.dart';

class EditingTextForm extends StatelessWidget {
  final String hintText;
  final TextEditingController valueController;
  final String placeholderText;

  const EditingTextForm({
    super.key,
    required this.hintText,
    required this.valueController,
    required this.placeholderText,
    bool? obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          hintText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $hintText';
            }
            return null;
          },
          controller: valueController,
          decoration: InputDecoration(
            hintText: placeholderText,
            hintStyle: const TextStyle(color: Color(0xFF727272), fontSize: 16),
            fillColor: const Color(0xFFECECEC),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF67864A)),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ],
    );
  }
}
