import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityProvider extends ChangeNotifier {
  final Map<String, int> _meditationHistory = {};
  final Map<String, int> _exerciseHistory = {};

  void completeMeditation() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _meditationHistory.update(today, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }
  int _dailyMeditationGoal = 2;
  int _dailyExerciseGoal = 1;

  int get dailyMeditationGoal => _dailyMeditationGoal;
  int get dailyExerciseGoal => _dailyExerciseGoal;

  void setDailyMeditationGoal(int value) {
    _dailyMeditationGoal = value;
    notifyListeners();
  }

  void setDailyExerciseGoal(int value) {
    _dailyExerciseGoal = value;
    notifyListeners();
  }


  int get todayMeditationCount {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _meditationHistory[today] ?? 0;
  }

  int get todayExerciseCount {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _exerciseHistory[today] ?? 0;
  }

  double get meditationProgress => (todayMeditationCount / dailyMeditationGoal).clamp(0, 1);
  double get exerciseProgress => (todayExerciseCount / dailyExerciseGoal).clamp(0, 1);

  void completeExercise() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _exerciseHistory.update(today, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  int get meditationCount {
    return _meditationHistory.values.fold(0, (sum, count) => sum + count);
  }

  int get exerciseCount {
    return _exerciseHistory.values.fold(0, (sum, count) => sum + count);
  }

  List<int> getLast7DaysMeditationData() {
    return _generateWeekData(_meditationHistory);
  }

  List<int> getLast7DaysExerciseData() {
    return _generateWeekData(_exerciseHistory);
  }

  List<int> _generateWeekData(Map<String, int> history) {
    final List<int> data = [];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      data.add(history[key] ?? 0);
    }
    return data;
  }

  int get successfulDaysThisWeek {
    int count = 0;
    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(date);

      final med = _meditationHistory[key] ?? 0;
      final ex = _exerciseHistory[key] ?? 0;

      if (med >= _dailyMeditationGoal && ex >= _dailyExerciseGoal) {
        count++;
      }
    }
    return count;
  }

  double get weeklySuccessRate => (successfulDaysThisWeek / 7).clamp(0, 1);




}
