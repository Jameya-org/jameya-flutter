import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final VoidCallback onTap;
  final String? trailingText;
  final IconData? trailingIcon;

  const SettingsTile({
    super.key,
    required this.title,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
    this.trailingText,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ),
            if (trailingText != null)
              Flexible(
                child: Text(
                  trailingText!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              )
            else
              Icon(
                trailingIcon ?? Icons.arrow_back_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsTile> tiles;

  const SettingsSection({super.key, required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1A7A6E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...tiles.asMap().entries.map((entry) {
            final isLast = entry.key == tiles.length - 1;
            return Column(
              children: [
                entry.value,
                if (!isLast)
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
