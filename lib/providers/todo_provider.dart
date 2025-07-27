import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import '../helpers/database_helper.dart';

class TodoProvider with ChangeNotifier {
  final List<Todo> _items = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;
  bool _isInitialized = false;

  List<Todo> get items => [..._items];
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  TodoProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    await _loadTodos();
    _isInitialized = true;
  }

  Future<void> _loadTodos() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final todos = await _dbHelper.getTodos();
      _items.clear();
      _items.addAll(todos);
    } catch (e) {
      // Handle error silently in production
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
    );
    
    await _dbHelper.insertTodo(newTodo);
    _items.insert(0, newTodo);
    notifyListeners();
  }

  Future<void> toggleTodoStatus(String id) async {
    final todoIndex = _items.indexWhere((item) => item.id == id);
    if (todoIndex >= 0) {
      final updatedTodo = Todo(
        id: _items[todoIndex].id,
        title: _items[todoIndex].title,
        isDone: !_items[todoIndex].isDone,
      );
      
      await _dbHelper.updateTodo(updatedTodo);
      _items[todoIndex] = updatedTodo;
      notifyListeners();
    }
  }

  Future<void> removeTodo(String id) async {
    await _dbHelper.deleteTodo(id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
