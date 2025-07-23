import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _items = [];

  List<Todo> get items => _items;

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
    );
    _items.insert(0, newTodo);
    notifyListeners();
  }

  Future<void> toggleTodoStatus(String id) async {
    final todoIndex = _items.indexWhere((item) => item.id == id);
    if (todoIndex >= 0) {
      _items[todoIndex] = Todo(
        id: _items[todoIndex].id,
        title: _items[todoIndex].title,
        isDone: !_items[todoIndex].isDone,
      );
      notifyListeners();
    }
  }

  Future<void> removeTodo(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
