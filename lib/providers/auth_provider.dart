import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  int? _selectedStudentId;

  int? get selectedStudentId => _selectedStudentId;

  bool get hasSelectedStudent => _selectedStudentId != null;

  void setSelectedStudentId(int id) {
    if (_selectedStudentId == id) return; // prevent unnecessary rebuilds
    _selectedStudentId = id;
    notifyListeners();
  }

  void clearSelectedStudent() {
    _selectedStudentId = null;
    notifyListeners();
  }
}