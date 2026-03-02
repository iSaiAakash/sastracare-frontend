import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final VoidCallback onVoiceTap;

  const CommonHeader({
    super.key,
    required this.title,
    required this.onVoiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider =
    Provider.of<LanguageProvider>(context, listen: false);

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF002B5C), Color(0xFF1A4A7A)],
            ),
          ),
          padding: const EdgeInsets.only(
              top: 45, bottom: 12, left: 16, right: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onVoiceTap,
                child: const Icon(
                  Icons.volume_up,
                  color: Color(0xFFFDB913),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 3,
          color: const Color(0xFFFDB913),
        ),
      ],
    );
  }
}