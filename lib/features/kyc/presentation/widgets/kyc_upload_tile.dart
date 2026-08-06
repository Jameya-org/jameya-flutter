import 'dart:io';
import 'package:flutter/material.dart';

class KycUploadTile extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onTap;

  const KycUploadTile({
    super.key,
    required this.label,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: file != null
                ? const Color(0xFF1A7A6E)
                : Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: file != null ? const Color(0xFFE8F6F3) : Colors.grey.shade50,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFD6EAF8),
              child: Icon(
                file != null ? Icons.check : Icons.person_outline,
                color: const Color(0xFF1A7A6E),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              file != null ? 'تم اختيار الملف' : 'اضغط لرفع الملف',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
