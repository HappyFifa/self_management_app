import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:self_management_app/providers/todo_provider.dart';
import 'package:self_management_app/helpers/database_helper.dart';
import 'package:self_management_app/models/todo_model.dart';

void main() {
  group('App Data Persistence Integration Tests', () {
    setUp(() async {
      // Clear and setup mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      DatabaseHelper.clearCache();
    });

    testWidgets('TodoProvider should persist data across rebuilds', (WidgetTester tester) async {
      // First app session - add some todos
      TodoProvider provider1 = TodoProvider();
      
      // Wait for initial loading to complete
      await tester.pumpAndSettle();
      
      // Add todos to first provider
      await provider1.addTodo('Test Todo 1');
      await provider1.addTodo('Test Todo 2');
      await provider1.addTodo('Test Todo 3');
      
      // Verify todos are in provider
      expect(provider1.items.length, 3);
      expect(provider1.items.any((t) => t.title == 'Test Todo 1'), true);
      
      // Simulate app restart by creating new provider
      DatabaseHelper.clearCache(); // Clear cache to simulate fresh start
      TodoProvider provider2 = TodoProvider();
      
      // Wait for data to load
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Check if data persisted
      expect(provider2.items.length, 3, reason: 'Data should persist across app restarts');
      expect(provider2.items.any((t) => t.title == 'Test Todo 1'), true);
      expect(provider2.items.any((t) => t.title == 'Test Todo 2'), true);
      expect(provider2.items.any((t) => t.title == 'Test Todo 3'), true);
    });

    testWidgets('TodoProvider should load data when widget is built', (WidgetTester tester) async {
      // Pre-populate data in storage
      final dbHelper = DatabaseHelper();
      await dbHelper.insertTodo(Todo(id: '1', title: 'Existing Todo 1', isDone: false));
      await dbHelper.insertTodo(Todo(id: '2', title: 'Existing Todo 2', isDone: true));
      
      // Create widget with provider
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (context) => TodoProvider(),
            child: Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return Scaffold(
                  body: Column(
                    children: [
                      Text('Todo Count: ${todoProvider.items.length}'),
                      ...todoProvider.items.map((todo) => 
                        ListTile(title: Text(todo.title))
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Wait for async loading
      await tester.pumpAndSettle();
      
      // Verify UI shows loaded data
      expect(find.text('Todo Count: 2'), findsOneWidget);
      expect(find.text('Existing Todo 1'), findsOneWidget);
      expect(find.text('Existing Todo 2'), findsOneWidget);
    });
  });
}
