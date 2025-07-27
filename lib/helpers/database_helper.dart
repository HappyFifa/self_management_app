import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import '../models/event_model.dart';
import '../models/reflection_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static SharedPreferences? _prefs;

  Future<SharedPreferences> get _storage async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Method to clear cache (for testing)
  static void clearCache() {
    _prefs = null;
  }

  // === TODOs OPERATIONS ===
  Future<void> insertTodo(Todo todo) async {
    final prefs = await _storage;
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == todo.id);
    todos.add(todo);
    final todosJson = todos.map((t) => {
      'id': t.id,
      'title': t.title,
      'isDone': t.isDone,
    }).toList();
    await prefs.setString('todos', jsonEncode(todosJson));
  }

  Future<List<Todo>> getTodos() async {
    final prefs = await _storage;
    final todosString = prefs.getString('todos');
    if (todosString == null) {
      return [];
    }
    
    final List<dynamic> todosJson = jsonDecode(todosString);
    return todosJson.map((json) => Todo(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
    )).toList();
  }

  Future<void> updateTodo(Todo todo) async {
    await insertTodo(todo); // For shared preferences, insert acts as update
  }

  Future<void> deleteTodo(String id) async {
    final prefs = await _storage;
    final todos = await getTodos();
    todos.removeWhere((t) => t.id == id);
    final todosJson = todos.map((t) => {
      'id': t.id,
      'title': t.title,
      'isDone': t.isDone,
    }).toList();
    await prefs.setString('todos', jsonEncode(todosJson));
  }

  // === EVENT OPERATIONS ===
  Future<void> insertEvent(Event event) async {
    final prefs = await _storage;
    final events = await getEvents();
    events.removeWhere((e) => e.id == event.id);
    events.add(event);
    final eventsJson = events.map((e) => {
      'id': e.id,
      'title': e.title,
      'date': e.date.toIso8601String(),
    }).toList();
    await prefs.setString('events', jsonEncode(eventsJson));
  }

  Future<List<Event>> getEvents() async {
    final prefs = await _storage;
    final eventsString = prefs.getString('events');
    if (eventsString == null) return [];
    
    final List<dynamic> eventsJson = jsonDecode(eventsString);
    return eventsJson.map((json) => Event(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
    )).toList();
  }

  Future<void> deleteEvent(String id) async {
    final prefs = await _storage;
    final events = await getEvents();
    events.removeWhere((e) => e.id == id);
    final eventsJson = events.map((e) => {
      'id': e.id,
      'title': e.title,
      'date': e.date.toIso8601String(),
    }).toList();
    await prefs.setString('events', jsonEncode(eventsJson));
  }

  // === REFLECTION OPERATIONS ===
  Future<void> insertReflection(Reflection reflection) async {
    final prefs = await _storage;
    final reflections = await getReflections();
    reflections.removeWhere((r) => r.id == reflection.id);
    reflections.add(reflection);
    final reflectionsJson = reflections.map((r) => {
      'id': r.id,
      'content': r.content,
      'date': r.date.toIso8601String(),
    }).toList();
    await prefs.setString('reflections', jsonEncode(reflectionsJson));
  }

  Future<List<Reflection>> getReflections() async {
    final prefs = await _storage;
    final reflectionsString = prefs.getString('reflections');
    if (reflectionsString == null) return [];
    
    final List<dynamic> reflectionsJson = jsonDecode(reflectionsString);
    final reflections = reflectionsJson.map((json) => Reflection(
      id: json['id'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    )).toList();
    
    // Sort by date descending
    reflections.sort((a, b) => b.date.compareTo(a.date));
    return reflections;
  }

  Future<void> deleteReflection(String id) async {
    final prefs = await _storage;
    final reflections = await getReflections();
    reflections.removeWhere((r) => r.id == id);
    final reflectionsJson = reflections.map((r) => {
      'id': r.id,
      'content': r.content,
      'date': r.date.toIso8601String(),
    }).toList();
    await prefs.setString('reflections', jsonEncode(reflectionsJson));
  }

  // === UTILITY ===
  Future<void> closeDatabase() async {
    // No action needed for SharedPreferences
  }
}
