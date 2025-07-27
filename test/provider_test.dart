import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:self_management_app/providers/todo_provider.dart';
import 'package:self_management_app/helpers/database_helper.dart';
import 'package:self_management_app/models/todo_model.dart';

void main() {
  group('TodoProvider Data Persistence Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      DatabaseHelper.clearCache();
    });

    test('TodoProvider should load existing data after initialization', () async {
      // Pre-populate data in storage
      final dbHelper = DatabaseHelper();
      await dbHelper.insertTodo(Todo(id: '1', title: 'Existing Todo', isDone: false));
      
      // Clear cache to simulate fresh start
      DatabaseHelper.clearCache();
      
      // Create provider
      final provider = TodoProvider();
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check if data is loaded
      expect(provider.isLoading, false);
      expect(provider.items.length, 1);
      expect(provider.items.first.title, 'Existing Todo');
    });

    test('TodoProvider should persist new todos', () async {
      final provider = TodoProvider();
      
      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Add todo
      await provider.addTodo('New Todo');
      
      // Verify in provider
      expect(provider.items.length, 1);
      expect(provider.items.first.title, 'New Todo');
      
      // Verify in storage
      final dbHelper = DatabaseHelper();
      final todos = await dbHelper.getTodos();
      expect(todos.length, 1);
      expect(todos.first.title, 'New Todo');
    });

    test('TodoProvider loading state should work correctly', () async {
      final provider = TodoProvider();
      
      // Should start with loading = true
      expect(provider.isLoading, true);
      expect(provider.isInitialized, false);
      
      // Wait for loading to complete
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Should finish loading
      expect(provider.isLoading, false);
      expect(provider.isInitialized, true);
    });
  });
}
