import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:self_management_app/helpers/database_helper.dart';
import 'package:self_management_app/models/todo_model.dart';
import 'package:self_management_app/models/event_model.dart';
import 'package:self_management_app/models/reflection_model.dart';

void main() {
  group('Data Persistence Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      // Clear SharedPreferences cache and set mock values
      SharedPreferences.setMockInitialValues({});
      DatabaseHelper.clearCache(); // Clear the cached SharedPreferences instance
      dbHelper = DatabaseHelper();
    });

    test('Should save and load todos correctly', () async {
      // Create test todo
      final todo = Todo(
        id: '1',
        title: 'Test Todo',
        isDone: false,
      );

      // Save todo
      await dbHelper.insertTodo(todo);

      // Load todos
      final todos = await dbHelper.getTodos();

      // Verify
      expect(todos.length, 1);
      expect(todos.first.id, '1');
      expect(todos.first.title, 'Test Todo');
      expect(todos.first.isDone, false);
    });

    test('Should update todo correctly', () async {
      // Create and save todo
      final todo = Todo(id: '1', title: 'Test Todo', isDone: false);
      await dbHelper.insertTodo(todo);

      // Update todo
      final updatedTodo = Todo(id: '1', title: 'Updated Todo', isDone: true);
      await dbHelper.updateTodo(updatedTodo);

      // Load and verify
      final todos = await dbHelper.getTodos();
      expect(todos.length, 1);
      expect(todos.first.title, 'Updated Todo');
      expect(todos.first.isDone, true);
    });

    test('Should save and load events correctly', () async {
      // Create test event
      final event = Event(
        id: '1',
        title: 'Test Event',
        date: DateTime(2025, 7, 24),
      );

      // Save event
      await dbHelper.insertEvent(event);

      // Load events
      final events = await dbHelper.getEvents();

      // Verify
      expect(events.length, 1);
      expect(events.first.id, '1');
      expect(events.first.title, 'Test Event');
      expect(events.first.date, DateTime(2025, 7, 24));
    });

    test('Should save and load reflections correctly', () async {
      // Create test reflection
      final reflection = Reflection(
        id: '1',
        content: 'Test reflection content',
        date: DateTime(2025, 7, 24),
      );

      // Save reflection
      await dbHelper.insertReflection(reflection);

      // Load reflections
      final reflections = await dbHelper.getReflections();

      // Verify
      expect(reflections.length, 1);
      expect(reflections.first.id, '1');
      expect(reflections.first.content, 'Test reflection content');
      expect(reflections.first.date, DateTime(2025, 7, 24));
    });

    test('Should persist data across multiple calls', () async {
      // Save multiple todos
      await dbHelper.insertTodo(Todo(id: '1', title: 'Todo 1', isDone: false));
      await dbHelper.insertTodo(Todo(id: '2', title: 'Todo 2', isDone: true));
      await dbHelper.insertTodo(Todo(id: '3', title: 'Todo 3', isDone: false));

      // Load todos
      final todos = await dbHelper.getTodos();

      // Verify all todos are saved
      expect(todos.length, 3);
      expect(todos.any((t) => t.title == 'Todo 1'), true);
      expect(todos.any((t) => t.title == 'Todo 2'), true);
      expect(todos.any((t) => t.title == 'Todo 3'), true);
    });

    test('Should delete todos correctly', () async {
      // Save todos
      await dbHelper.insertTodo(Todo(id: '1', title: 'Todo 1', isDone: false));
      await dbHelper.insertTodo(Todo(id: '2', title: 'Todo 2', isDone: false));

      // Delete one todo
      await dbHelper.deleteTodo('1');

      // Load and verify
      final todos = await dbHelper.getTodos();
      expect(todos.length, 1);
      expect(todos.first.id, '2');
    });
  });
}
