import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/services/api_service.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/widgets/common_header.dart';
import '../services/audio_player_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState
    extends State<AttendanceScreen> {

  List<int> _semesters = [];
  int? _selectedSemester;

  Map<String, dynamic>? _attendanceData;

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

      await _loadAttendance();

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

  Future<void> _loadAttendance() async {

    if (_selectedSemester == null) return;

    try {

      final data =
      await ApiService.getAttendance(
        studentId: _studentId,
        semester: _selectedSemester!,
      );

      if (!mounted) return;

      setState(() {
        _attendanceData = data;
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

    final percentage =
        (_attendanceData?["percentage"] as num?)
            ?.toDouble() ?? 0.0;

    final total =
        (_attendanceData?["totalDays"] as num?)
            ?.toInt() ?? 0;

    final present =
        (_attendanceData?["presentDays"] as num?)
            ?.toInt() ?? 0;

    final absent = total - present;

    return Scaffold(
      body: Column(
        children: [

          CommonHeader(
            title: languageProvider.translate('attendance'),
            onVoiceTap: () async {

              if (_selectedSemester == null) return;

              final bytes =
              await ApiService.getAttendanceAudio(
                studentId: _studentId,
                semester: _selectedSemester!,
              );

              await AudioPlayerService.playBytes(bytes);
            },
          ),

          Expanded(
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

                        await _loadAttendance();
                      },
                      underline: const SizedBox(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    "${percentage.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildStatRow(
                      languageProvider.translate('total_days'),
                      total.toString()),

                  _buildStatRow(
                      languageProvider.translate('present_days'),
                      present.toString()),

                  _buildStatRow(
                      languageProvider.translate('absent_days'),
                      absent.toString()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
      String label,
      String value) {

    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}