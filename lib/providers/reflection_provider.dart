import 'package:flutter/material.dart';
import '../models/reflection_model.dart';
import '../helpers/database_helper.dart';

class ReflectionProvider with ChangeNotifier {
  final List<Reflection> _reflections = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;
  bool _isInitialized = false;

  List<Reflection> get reflections => [..._reflections];
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  ReflectionProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    await _loadReflections();
    _isInitialized = true;
  }

  Future<void> _loadReflections() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final reflections = await _dbHelper.getReflections();
      _reflections.clear();
      _reflections.addAll(reflections);
    } catch (e) {
      // Handle error silently in production
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReflection(String content) async {
    final newReflection = Reflection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      date: DateTime.now(),
    );
    
    await _dbHelper.insertReflection(newReflection);
    _reflections.insert(0, newReflection);
    notifyListeners();
  }

  Future<void> removeReflection(String id) async {
    await _dbHelper.deleteReflection(id);
    _reflections.removeWhere((reflection) => reflection.id == id);
    notifyListeners();
  }
}
