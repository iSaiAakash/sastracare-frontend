import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import 'package:sastra_parent/services/api_service.dart';
import 'package:sastra_parent/widgets/common_header.dart';
import '../services/audio_player_service.dart';

class SgpaCgpaScreen extends StatefulWidget {
  const SgpaCgpaScreen({super.key});

  @override
  State<SgpaCgpaScreen> createState() => _SgpaCgpaScreenState();
}

class _SgpaCgpaScreenState extends State<SgpaCgpaScreen> {

  List<int> _semesters = [];
  int? _selectedSemester;

  Map<String, dynamic>? _sgpaData;
  Map<String, dynamic>? _cgpaData;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {

      final studentId =
          context.read<AuthProvider>().selectedStudentId;

      if (studentId == null) {
        throw Exception("No student selected");
      }

      _semesters =
      await ApiService.getAvailableSemesters(studentId);

      if (_semesters.isEmpty) {
        throw Exception("No semesters available");
      }

      _selectedSemester = _semesters.first;

      await _loadSgpa(studentId);

      if (!mounted) return;

      setState(() {
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

  Future<void> _loadSgpa(int studentId) async {

    if (_selectedSemester == null) return;

    try {

      final sgpa = await ApiService.getSgpa(
        studentId: studentId,
        semester: _selectedSemester!,
      );

      final cgpa = await ApiService.getCgpa(
        studentId: studentId,
      );

      if (!mounted) return;

      setState(() {
        _sgpaData = sgpa;
        _cgpaData = cgpa;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
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
        body: Center(child: Text("Error: $_error")),
      );
    }

    final sgpa =
        (_sgpaData?["sgpa"] as num?)?.toDouble() ?? 0.0;

    final semester =
        (_sgpaData?["semesterNumber"] as num?)?.toInt() ?? 0;

    final cgpa =
        (_cgpaData?["cgpa"] as num?)?.toDouble() ?? 0.0;

    final studentId =
        context.read<AuthProvider>().selectedStudentId;

    return Scaffold(
      body: Column(
        children: [

          CommonHeader(
            title: languageProvider.translate('sgpa_cgpa'),
            onVoiceTap: () async {
              if (_selectedSemester == null ||
                  studentId == null) return;

              final bytes =
              await ApiService.getSgpaAudio(
                studentId: studentId,
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
                        borderRadius: BorderRadius.circular(12),
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
                          if (value == null ||
                              studentId == null) return;

                          setState(() {
                            _selectedSemester = value;
                          });

                          await _loadSgpa(studentId);
                        },
                        underline: const SizedBox(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 40,
                            color: Color(0xFFFDB913),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cgpa.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002B5C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(languageProvider.translate('cgpa')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "${languageProvider.translate('semester')} $semester",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            sgpa.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002B5C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(languageProvider.translate('sgpa_cgpa')),
                        ],
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
}