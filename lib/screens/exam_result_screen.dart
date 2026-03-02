import 'package:flutter/material.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import 'package:sastra_parent/services/api_service.dart';
import 'package:sastra_parent/widgets/common_header.dart';
import '../services/audio_player_service.dart';
import 'package:provider/provider.dart';

class ExamResultsScreen extends StatefulWidget {
  const ExamResultsScreen({super.key});

  @override
  State<ExamResultsScreen> createState() =>
      _ExamResultsScreenState();
}

class _ExamResultsScreenState
    extends State<ExamResultsScreen> {

  List<int> _semesters = [];
  int? _selectedSemester;

  Map<String, dynamic>? _resultData;

  bool _isLoading = true;
  String? _error;

  late int _studentId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {

      // ✅ SINGLE SOURCE OF TRUTH
      final auth =
      Provider.of<AuthProvider>(context, listen: false);

      final id = auth.selectedStudentId;

      if (id == null) {
        throw Exception("No student selected");
      }

      _studentId = id;

      final semesters =
      await ApiService.getAvailableSemesters(_studentId);

      if (semesters.isEmpty) {
        throw Exception("No semesters available");
      }

      setState(() {
        _semesters = semesters;
        _selectedSemester = semesters.first;
      });

      await _loadResult();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error =
            e.toString().replaceAll("Exception: ", "");
        _isLoading = false;
      });
    }
  }

  Future<void> _loadResult() async {

    if (_selectedSemester == null) return;

    try {

      final result =
      await ApiService.getResult(
        studentId: _studentId,
        semester: _selectedSemester!,
      );

      if (!mounted) return;

      setState(() {
        _resultData = result;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error =
            e.toString().replaceAll("Exception: ", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final languageProvider =
    Provider.of<LanguageProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Text("Error: $_error"),
        ),
      );
    }

    final totalSubjects =
        (_resultData?["totalSubjects"] as num?)?.toInt() ?? 0;

    final passed =
        (_resultData?["passed"] as num?)?.toInt() ?? 0;

    final arrears =
        (_resultData?["arrears"] as num?)?.toInt() ?? 0;

    final subjects =
        (_resultData?["subjects"] as List<dynamic>?) ?? [];

    return Scaffold(
      body: Column(
        children: [

          CommonHeader(
            title: languageProvider.translate('exam_results'),
            onVoiceTap: () async {

              if (_selectedSemester == null) return;

              final bytes =
              await ApiService.getResultAudio(
                studentId: _studentId,
                semester: _selectedSemester!,
              );

              await AudioPlayerService.playBytes(bytes);
            },
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xFFF5F8FF),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: _selectedSemester,
                        items: _semesters.map((sem) {
                          return DropdownMenuItem(
                            value: sem,
                            child: Text(
                              "${languageProvider.translate('semester')} $sem",
                            ),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value == null) return;

                          setState(() {
                            _selectedSemester = value;
                          });

                          await _loadResult();
                        },
                        underline: const SizedBox(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                        children: [
                          _summaryItem(
                            languageProvider.translate('total_subjects'),
                            totalSubjects.toString(),
                            Icons.menu_book,
                          ),
                          _summaryItem(
                            languageProvider.translate('passed'),
                            passed.toString(),
                            Icons.check_circle,
                            Colors.green,
                          ),
                          _summaryItem(
                            languageProvider.translate('arrears'),
                            arrears.toString(),
                            Icons.warning,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: Column(
                        children:
                        subjects.map((subject) {

                          final name =
                              subject["subjectName"] ?? "";

                          final marks =
                              subject["totalMarks"] ?? 0;

                          final grade =
                              subject["grade"] ?? "";

                          final status =
                              subject["status"] ?? "";

                          final isPass =
                              status == "PASS";

                          return Padding(
                            padding:
                            const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    name,
                                    style:
                                    const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    marks.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    grade,
                                    textAlign: TextAlign.center,
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2),
                                    decoration:
                                    BoxDecoration(
                                      color: isPass
                                          ? Colors.green
                                          .withOpacity(0.1)
                                          : Colors.red
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      status,
                                      textAlign:
                                      TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight:
                                        FontWeight.bold,
                                        color: isPass
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
      String label,
      String value,
      IconData icon,
      [Color color =
      const Color(0xFF002B5C)]) {

    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}