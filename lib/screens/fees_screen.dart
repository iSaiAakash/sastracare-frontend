import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sastra_parent/providers/language_provider.dart';
import 'package:sastra_parent/providers/auth_provider.dart';
import 'package:sastra_parent/services/api_service.dart';
import 'package:sastra_parent/widgets/common_header.dart';
import '../services/audio_player_service.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {

  List<int> _semesters = [];
  int? _selectedSemester;

  Map<String, dynamic>? _feesData;

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

      final studentId = auth.selectedStudentId;

      if (studentId == null) {
        throw Exception("No student selected");
      }

      _studentId = studentId;

      // ✅ FIXED: pass studentId
      _semesters = await ApiService.getAvailableSemesters(_studentId);

      if (_semesters.isEmpty) {
        throw Exception("No semesters available");
      }

      _selectedSemester = _semesters.first;

      await _loadFees();

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

  Future<void> _loadFees() async {

    if (_selectedSemester == null) return;

    try {

      final fees = await ApiService.getFees(
        studentId: _studentId,   // ✅ FIXED
        semester: _selectedSemester!,
      );

      if (!mounted) return;

      setState(() {
        _feesData = fees;
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

    final totalAmount =
        (_feesData?["totalAmount"] as num?)?.toDouble() ?? 0;

    final paidAmount =
        (_feesData?["paidAmount"] as num?)?.toDouble() ?? 0;

    final pendingAmount =
        (_feesData?["pendingAmount"] as num?)?.toDouble() ?? 0;

    return Scaffold(
      body: Column(
        children: [

          CommonHeader(
            title: languageProvider.translate('fees'),
            onVoiceTap: () async {
              if (_selectedSemester == null) return;

              final bytes = await ApiService.getFeesAudio(
                studentId: _studentId,   // ✅ FIXED
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
                          if (value == null) return;

                          setState(() {
                            _selectedSemester = value;
                          });

                          await _loadFees();
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
                            Icons.account_balance_wallet,
                            size: 40,
                            color: Color(0xFF002B5C),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "₹${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF002B5C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(languageProvider.translate('total_fees')),
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
                          _buildRow(
                            languageProvider.translate('paid'),
                            paidAmount,
                            Colors.green,
                          ),
                          const SizedBox(height: 10),
                          _buildRow(
                            languageProvider.translate('pending'),
                            pendingAmount,
                            Colors.orange,
                          ),
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

  Widget _buildRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          "₹${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}