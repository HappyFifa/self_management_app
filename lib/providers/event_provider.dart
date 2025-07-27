import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';
import '../helpers/database_helper.dart';

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
  );
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool _isLoading = true;
  bool _isInitialized = false;

  Map<DateTime, List<Event>> get events => _events;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  EventProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    await _loadEvents();
    _isInitialized = true;
  }

  Future<void> _loadEvents() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final events = await _dbHelper.getEvents();
      _events.clear();
      
      for (final event in events) {
        final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
        if (_events[eventDate] != null) {
          _events[eventDate]!.add(event);
        } else {
          _events[eventDate] = [event];
        }
      }
    } catch (e) {
      // Handle error silently in production
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Event> getEventsForDay(DateTime day) => _events[day] ?? [];

  Future<void> addEvent(DateTime day, String title) async {
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: day,
    );
    
    await _dbHelper.insertEvent(newEvent);
    
    if (_events[day] != null) {
      _events[day]!.add(newEvent);
    } else {
      _events[day] = [newEvent];
    }
    notifyListeners();
  }

  Future<void> removeEvent(DateTime day, Event event) async {
    await _dbHelper.deleteEvent(event.id);
    
    if (_events[day] != null) {
      _events[day]!.remove(event);
      if (_events[day]!.isEmpty) {
        _events.remove(day);
      }
      notifyListeners();
    }
  }
}
