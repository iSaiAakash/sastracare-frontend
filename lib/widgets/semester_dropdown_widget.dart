import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import '../services/api_service.dart';

class SemesterDropdownWidget extends StatefulWidget {
  final Function(int) onSemesterChanged;

  const SemesterDropdownWidget({
    super.key,
    required this.onSemesterChanged,
  });

  @override
  State<SemesterDropdownWidget> createState() =>
      _SemesterDropdownWidgetState();
}

class _SemesterDropdownWidgetState
    extends State<SemesterDropdownWidget> {

  List<int> semesters = [];
  int? selectedSemester;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadSemesters();
  }

  Future<void> _loadSemesters() async {
    try {

      final studentId =
          context.read<AuthProvider>().selectedStudentId;

      if (studentId == null) {
        throw Exception("No student selected");
      }

      final data =
      await ApiService.getAvailableSemesters(studentId);

      if (!mounted) return;

      setState(() {
        semesters = data;
        selectedSemester =
        semesters.isNotEmpty ? semesters.first : null;
        isLoading = false;
      });

      if (selectedSemester != null) {
        widget.onSemesterChanged(selectedSemester!);
      }

    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const CircularProgressIndicator();
    }

    if (error != null) {
      return Text(error!,
          style: const TextStyle(color: Colors.red));
    }

    if (semesters.isEmpty) {
      return const Text("No semesters available");
    }

    return DropdownButton<int>(
      value: selectedSemester,
      isExpanded: true,
      items: semesters.map((sem) {
        return DropdownMenuItem(
          value: sem,
          child: Text("Semester $sem"),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedSemester = value;
        });

        if (value != null) {
          widget.onSemesterChanged(value);
        }
      },
    );
  }
}