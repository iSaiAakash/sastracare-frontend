import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import 'package:sastra_parent/services/api_service.dart';
import 'package:sastra_parent/services/tts_service.dart';
import 'package:sastra_parent/screens/dashboard_screen.dart';
import 'package:sastra_parent/utils/voice_text.dart';

// SASTRA Colors
const Color sastraNavyBlue = Color(0xFF002B5C);
const Color sastraGold = Color(0xFFFDB913);
const Color sastraWhite = Color(0xFFFFFFFF);
const Color sastraLightGray = Color(0xFFF5F8FF);

class StudentSelectionScreen extends StatefulWidget {
  const StudentSelectionScreen({super.key});

  @override
  State<StudentSelectionScreen> createState() => _StudentSelectionScreenState();
}

class _StudentSelectionScreenState extends State<StudentSelectionScreen> {
  final TTSService _ttsService = TTSService();
  List<dynamic> _students = [];
  int? _selectedStudentIndex;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final data = await ApiService.getMyChildren();
      if (!mounted) return;
      setState(() {
        _students = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _speakText(String text) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    _ttsService.speak(text, languageCode: languageProvider.currentLanguage);
  }

  void _goBack() {
    final languageProvider = context.read<LanguageProvider>();
    _speakText(VoiceText.getGoingBack(languageProvider.currentLanguage));
    Navigator.pop(context);
  }

  Future<void> _continueToDashboard() async {
    if (_selectedStudentIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a student"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final selectedStudent = _students[_selectedStudentIndex!];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setSelectedStudentId(selectedStudent["id"] as int);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(student: selectedStudent),
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

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text("Error: $_error")),
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
            padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _goBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: sastraWhite.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: sastraWhite,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    languageProvider.translate('select_student'),
                    style: const TextStyle(
                      color: sastraWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          Container(height: 4, color: sastraGold),

          Expanded(
            child: Container(
              color: sastraLightGray,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final student = _students[index];
                  final isSelected = _selectedStudentIndex == index;

                  // Colors for different students
                  final List<Color> studentColors = [
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.purple,
                    Colors.teal,
                  ];
                  final studentColor = studentColors[index % studentColors.length];

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedStudentIndex = index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? studentColor.withValues(alpha: 0.1) : sastraWhite,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? studentColor : Colors.grey.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Student Photo
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: studentColor.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: studentColor, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                student["name"][0],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: studentColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Student Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student["name"],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? studentColor : sastraNavyBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  student["registerNumber"] ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Selection Indicator
                          if (isSelected)
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: studentColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: sastraWhite,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Continue Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _continueToDashboard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: sastraNavyBlue,
                  foregroundColor: sastraWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}