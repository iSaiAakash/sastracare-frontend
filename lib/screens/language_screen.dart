import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/screens/mobile_verification.dart';

// SASTRA Colors
const Color sastraNavyBlue = Color(0xFF002B5C);
const Color sastraGold = Color(0xFFFDB913);
const Color sastraWhite = Color(0xFFFFFFFF);
const Color sastraLightGray = Color(0xFFF5F5F5);

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // SASTRA Banner
          Container(
            width: double.infinity,
            color: sastraNavyBlue,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: const Column(
              children: [
                Text(
                  'SASTRA',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: sastraGold,
                    letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ENGINEERING · MANAGEMENT · LAW · SCIENCES · HUMANITIES · EDUCATION',
                  style: TextStyle(
                    fontSize: 12,
                    color: sastraWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'DEEMED TO BE UNIVERSITY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: sastraGold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '(U/S 3 of the UGC Act, 1956)',
                  style: TextStyle(
                    fontSize: 11,
                    color: sastraWhite,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'THINK MERIT | THINK TRANSPARENCY | THINK SASTRA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: sastraWhite,
                  ),
                ),
              ],
            ),
          ),

          // Gold accent line
          Container(
            height: 4,
            color: sastraGold,
          ),

          // Main content
          Expanded(
            child: Container(
              color: sastraLightGray,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Select Language Title
                      Center(
                        child: Consumer<LanguageProvider>(
                          builder: (context, languageProvider, child) {
                            return Text(
                              languageProvider.translate('select_language'),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: sastraNavyBlue,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Language Cards
                      _buildLanguageCard(
                        context,
                        'தமிழ்',
                        'தமிழ்',
                        Icons.translate,
                        const Color(0xFFB43C3C),
                        '🇮🇳',
                        'ta',
                        'Tamil',
                      ),

                      const SizedBox(height: 12),

                      _buildLanguageCard(
                        context,
                        'English',
                        'English',
                        Icons.language,
                        Colors.blue,
                        '🇬🇧',
                        'en',
                        'English',
                      ),

                      const SizedBox(height: 12),

                      _buildLanguageCard(
                        context,
                        'తెలుగు',
                        'తెలుగు',
                        Icons.translate,
                        const Color(0xFFC95A0F),
                        '🇮🇳',
                        'te',
                        'Telugu',
                      ),

                      const SizedBox(height: 12),

                      _buildLanguageCard(
                        context,
                        'हिन्दी',
                        'हिन्दी',
                        Icons.translate,
                        const Color(0xFF2E7D32),
                        '🇮🇳',
                        'hi',
                        'Hindi',
                      ),

                      const SizedBox(height: 30),

                      // Footer
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 2,
                              color: sastraGold,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'SASTRA - சிறப்புக் கல்வி',
                              style: TextStyle(
                                color: sastraNavyBlue,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
      BuildContext context,
      String language,
      String subtitle,
      IconData icon,
      Color iconColor,
      String flag,
      String languageCode,
      String languageName,
      ) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              languageProvider.setLanguage(languageCode, languageName);

              String message;
              if (languageCode == 'ta') {
                message = 'தமிழ் மொழி தேர்ந்தெடுக்கப்பட்டது';
              } else if (languageCode == 'te') {
                message = 'తెలుగు భాష ఎంపిక చేయబడింది';
              } else if (languageCode == 'hi') {
                message = 'हिन्दी भाषा चयनित';
              } else {
                message = 'English selected';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: sastraNavyBlue,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MobileVerificationScreen(),
                  ),
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(flag, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          language,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: sastraNavyBlue,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: sastraGold.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: sastraGold,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}