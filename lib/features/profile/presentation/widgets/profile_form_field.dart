import 'package:flutter/material.dart';

class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final TextDirection textDirection;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.onTap,
    this.textDirection = TextDirection.rtl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          textDirection: textDirection,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1A7A6E)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }
}
