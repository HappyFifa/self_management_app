import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:self_management_app/providers/todo_provider.dart';
import 'package:self_management_app/providers/event_provider.dart';
import 'package:self_management_app/providers/reflection_provider.dart';
import 'package:self_management_app/helpers/database_helper.dart';

void main() {
  group('Full App Data Persistence Test', () {
    setUp(() async {
      await initializeDateFormatting('id_ID', null);
      SharedPreferences.setMockInitialValues({});
      DatabaseHelper.clearCache();
    });

    testWidgets('Data should persist after app restart simulation', (WidgetTester tester) async {
      // === FIRST APP SESSION ===
      
      // Create providers (simulating app startup)
      final todoProvider1 = TodoProvider();
      final eventProvider1 = EventProvider();
      final reflectionProvider1 = ReflectionProvider();
      
      // Wait for initial load
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(milliseconds: 500)); // Allow async loading
      
      // Add some data
      await todoProvider1.addTodo('Test Todo 1 - Session 1');
      await todoProvider1.addTodo('Test Todo 2 - Session 1');
      
      await eventProvider1.addEvent(DateTime.now(), 'Test Event 1');
      
      await reflectionProvider1.addReflection('This is my first reflection');
      
      // Verify data is there
      expect(todoProvider1.items.length, 2);
      expect(eventProvider1.events.length, 1);
      expect(reflectionProvider1.reflections.length, 1);
      
      // === SIMULATE APP RESTART ===
      
      // Clear cache to simulate fresh app start
      DatabaseHelper.clearCache();
      
      // Create new providers (simulating new app instance)
      final todoProvider2 = TodoProvider();
      final eventProvider2 = EventProvider();
      final reflectionProvider2 = ReflectionProvider();
      
      // Wait for data to load from storage
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check if data persisted
      expect(todoProvider2.items.length, 2, reason: 'Todos should persist across sessions');
      expect(eventProvider2.events.length, 1, reason: 'Events should persist across sessions');
      expect(reflectionProvider2.reflections.length, 1, reason: 'Reflections should persist across sessions');
      
      // Verify specific data
      expect(todoProvider2.items.any((t) => t.title == 'Test Todo 1 - Session 1'), true);
      expect(todoProvider2.items.any((t) => t.title == 'Test Todo 2 - Session 1'), true);
      
      // Check event data (events are stored by date)
      final eventValues = eventProvider2.events.values.expand((e) => e).toList();
      expect(eventValues.any((e) => e.title == 'Test Event 1'), true);
      
      expect(reflectionProvider2.reflections.any((r) => r.content == 'This is my first reflection'), true);
    });

    testWidgets('Providers should handle empty storage gracefully', (WidgetTester tester) async {
      // Start with empty storage
      final todoProvider = TodoProvider();
      final eventProvider = EventProvider();
      final reflectionProvider = ReflectionProvider();
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Should start with empty lists
      expect(todoProvider.items.length, 0);
      expect(eventProvider.events.length, 0);
      expect(reflectionProvider.reflections.length, 0);
    });
  });
}
