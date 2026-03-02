import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../services/api_service.dart';
import '../services/tts_service.dart';
import 'exam_result_screen.dart';
import 'mobile_verification.dart';
import 'attendance_screen.dart';
import 'sgpa_cgpa_screen.dart';
import 'fees_screen.dart';
import '../utils/voice_text.dart';

// SASTRA Official Colors
const Color sastraNavyBlue = Color(0xFF002B5C);
const Color sastraGold = Color(0xFFFDB913);
const Color sastraWhite = Color(0xFFFFFFFF);
const Color sastraLightGray = Color(0xFFF5F8FF);

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> student;

  const DashboardScreen({
    super.key,
    required this.student,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String studentName = "";
  String regNumber = "";
  String branch = "";
  final TTSService _ttsService = TTSService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    try {
      final selectedId =
          context.read<AuthProvider>().selectedStudentId;

      if (selectedId == null) {
        throw Exception("No student selected");
      }

      final children = await ApiService.getMyChildren();

      final student = children.firstWhere(
            (s) => s["id"] == selectedId,
      );

      if (!mounted) return;

      setState(() {
        studentName = student["name"] ?? "";
        regNumber = student["registerNumber"] ?? "";
        branch = student["program"] ?? "";
        _isLoading = false;
      });

    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _speakText(String text) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    _ttsService.speak(text, languageCode: languageProvider.currentLanguage);
  }

  void _showLogoutDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(languageProvider.translate('logout')),
        content: Text(languageProvider.translate('logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MobileVerificationScreen()),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(languageProvider.translate('logout')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // Header with SASTRA gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [sastraNavyBlue, Color(0xFF1A4A7A)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Menu Icon
                    GestureDetector(
                      onTap: () => _showLogoutDialog(context),
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: sastraWhite.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.menu,
                          color: sastraWhite,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        languageProvider.translate('dashboard'),
                        style: const TextStyle(
                          color: sastraWhite,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Student Info Card
                GestureDetector(
                  onTap: () {
                    _speakText(VoiceText.getStudentInfo(
                      languageProvider.currentLanguage,
                      studentName,
                      regNumber,
                      branch,
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: sastraWhite.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: sastraGold,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              studentName.isNotEmpty ? studentName[0] : 'S',
                              style: const TextStyle(
                                color: sastraNavyBlue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentName,
                                style: const TextStyle(
                                  color: sastraWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                regNumber,
                                style: TextStyle(
                                  color: sastraWhite.withValues(alpha: 0.8),
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                branch,
                                style: const TextStyle(
                                  color: sastraGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.volume_up,
                          color: sastraGold,
                          size: 20,
                        ),
                      ],
                    ),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            languageProvider.translate('welcome'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: sastraNavyBlue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            languageProvider.translate('select_option'),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _speakText(VoiceText.getWelcome(languageProvider.currentLanguage));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: sastraNavyBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.volume_up,
                            color: sastraNavyBlue,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Dashboard Options Grid - 4 Cards with icons and colors
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                      children: [
                        // Attendance Card
                        _buildDashboardCard(
                          languageProvider.translate('attendance'),
                          Icons.calendar_today,
                          Colors.blue,
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                          ),
                        ),
                        // SGPA/CGPA Card
                        _buildDashboardCard(
                          languageProvider.translate('sgpa_cgpa'),
                          Icons.grade,
                          Colors.green,
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SgpaCgpaScreen()),
                          ),
                        ),
                        // Exam Results Card
                        _buildDashboardCard(
                          languageProvider.translate('exam_results'),
                          Icons.assignment,
                          Colors.orange,
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ExamResultsScreen()),
                          ),
                        ),
                        // Fees Card
                        _buildDashboardCard(
                          languageProvider.translate('fees'),
                          Icons.payment,
                          Colors.purple,
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FeesScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: sastraWhite,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: sastraNavyBlue,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}