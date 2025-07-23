import 'package:flutter/material.dart';
import '../models/reflection_model.dart';

class ReflectionProvider with ChangeNotifier {
  final List<Reflection> _reflections = [];
  List<Reflection> get reflections => [..._reflections];

  void addReflection(String content) {
    final newReflection = Reflection(
      id: DateTime.now().toString(),
      content: content,
      date: DateTime.now(),
    );
    _reflections.insert(0, newReflection);
    notifyListeners();
  }

  // METHOD HAPUS DITAMBAHKAN DI SINI
  void removeReflection(String id) {
    _reflections.removeWhere((reflection) => reflection.id == id);
    notifyListeners();
  }
}
