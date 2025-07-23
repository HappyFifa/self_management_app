import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/event_model.dart';

class EventProvider with ChangeNotifier {
  final Map<DateTime, List<Event>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (key) => key.day * 1000000 + key.month * 10000 + key.year,
  );

  Map<DateTime, List<Event>> get events => _events;

  List<Event> getEventsForDay(DateTime day) => _events[day] ?? [];

  void addEvent(DateTime day, String title) {
    final newEvent = Event(title);
    if (_events[day] != null) {
      _events[day]!.add(newEvent);
    } else {
      _events[day] = [newEvent];
    }
    notifyListeners();
  }

  // METHOD HAPUS DITAMBAHKAN DI SINI
  void removeEvent(DateTime day, Event event) {
    if (_events[day] != null) {
      _events[day]!.remove(event);
      if (_events[day]!.isEmpty) {
        _events.remove(day);
      }
      notifyListeners();
    }
  }
}
