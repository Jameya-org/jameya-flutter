import 'package:flutter/material.dart';
import '../../data/models/profile_model.dart';

/// Profile header widget showing user avatar (initials) and name/email.
/// Avatar upload is removed — the API no longer provides/accepts an avatar URL.
class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        CircleAvatar(
          radius: 52,
          backgroundColor: Colors.grey.shade200,
          child: Text(
            profile.legalName.isNotEmpty
                ? profile.legalName[0].toUpperCase()
                : '؟',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A7A6E),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            profile.legalName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            profile.email,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
