import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/screens/mobile_verification.dart';
import 'package:sastra_parent/screens/student_selection_screen.dart';
import 'package:sastra_parent/services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: languageProvider.translate('app_title'),
            theme: ThemeData(
              fontFamily: 'Roboto',
              primaryColor: const Color(0xFF002B5C),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color(0xFF002B5C),
                secondary: const Color(0xFFFDB913),
              ),
            ),
            home: const SplashScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    await Future.delayed(const Duration(seconds: 2));

    final isLoggedIn = await ApiService.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const StudentSelectionScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LanguageScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SASTRA Logo
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF002B5C),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF002B5C).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
                border: Border.all(
                  color: const Color(0xFFFDB913),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/sastra_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SASTRA',
                            style: TextStyle(
                              color: Color(0xFFFDB913),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'DEEMED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'SHANMUGA ARTS SCIENCE TECHNOLOGY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF002B5C),
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'RESEARCH ACADEMY',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF002B5C),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 2,
              color: const Color(0xFFFDB913),
            ),
            const SizedBox(height: 20),
            const Text(
              'Parent Academic Voice App',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // SASTRA Banner Image - REDUCED HEIGHT to eliminate white gap
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 5, bottom: 0), // Minimal padding
            child: Center(
              child: Image.asset(
                'assets/images/sastra_banner.png',
                width: double.infinity,
                height: 100, // REDUCED from 160 to 100
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 100,
                    color: const Color(0xFF002B5C),
                    child: const Center(
                      child: Text(
                        'SASTRA',
                        style: TextStyle(
                          color: Color(0xFFFDB913),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // SOLID BLUE LINE - Now directly below image with no gap
          Container(
            height: 4,
            color: const Color(0xFF002B5C), // SASTRA Navy Blue
          ),

          // Main content with Cards
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Language Section Title
                      Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                          return Center(
                            child: Text(
                              languageProvider.translate('select_language'),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF002B5C),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // 1. TAMIL
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

                      // 2. ENGLISH
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

                      // 3. TELUGU
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

                      // 4. HINDI
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

                      const SizedBox(height: 25),

                      // Footer
                      Consumer<LanguageProvider>(
                        builder: (context, languageProvider, child) {
                          return Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 2,
                                  color: const Color(0xFFFDB913),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'SASTRA - சிறப்புக் கல்வி',
                                  style: TextStyle(
                                    color: Color(0xFF002B5C),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
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
                  backgroundColor: const Color(0xFF002B5C),
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
                            color: Color(0xFF002B5C),
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
                      color: const Color(0xFFFDB913).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFFFDB913),
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