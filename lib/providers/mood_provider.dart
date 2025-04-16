import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodProvider extends ChangeNotifier {
  final List<Map<String, String>> _moodHistory = [];

  List<Map<String, String>> get moodHistory => _moodHistory.reversed.toList();

  void addMood(String emoji) {
    String formattedDate = DateFormat('dd MMM yyyy – HH:mm', 'tr_TR').format(DateTime.now());
    print("DEBUG: addMood çağrıldı. Emoji: $emoji"); // ⬅ bunu ekle

    _moodHistory.add({
      'mood': emoji,
      'date': formattedDate,
    });

    notifyListeners();
  }
}
