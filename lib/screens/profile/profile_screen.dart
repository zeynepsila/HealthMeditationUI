import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme_notifier.dart';
import '../../providers/mood_provider.dart';
import '../../providers/activity_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moodHistory = Provider.of<MoodProvider>(context).moodHistory;
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(height: 16),
            const Text(
              "Zeynep Sıla",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bugünkü ruh halin: 👀",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () {
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
              },
              icon: const Icon(Icons.brightness_6),
              label: const Text("Temayı Değiştir"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => _openGoalDialog(context),
              icon: const Icon(Icons.flag),
              label: const Text("Günlük Hedefleri Belirle"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🕒 Ruh Hali Geçmişi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 12),
            moodHistory.isEmpty
                ? const Text("Henüz bir ruh hali geçmişi yok.")
                : Column(
              children: moodHistory.map((entry) {
                return ListTile(
                  leading: Text(entry['mood'] ?? "", style: const TextStyle(fontSize: 24)),
                  title: Text(entry['date'] ?? ""),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _openGoalDialog(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    int meditationGoal = activityProvider.dailyMeditationGoal;
    int exerciseGoal = activityProvider.dailyExerciseGoal;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Günlük Hedef Ayarları"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Meditasyon Hedefi"),
                Slider(
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: meditationGoal.toString(),
                  value: meditationGoal.toDouble(),
                  onChanged: (value) {
                    setState(() => meditationGoal = value.toInt());
                  },
                ),
                const SizedBox(height: 12),
                const Text("Egzersiz Hedefi"),
                Slider(
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: exerciseGoal.toString(),
                  value: exerciseGoal.toDouble(),
                  onChanged: (value) {
                    setState(() => exerciseGoal = value.toInt());
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  activityProvider.setDailyMeditationGoal(meditationGoal);
                  activityProvider.setDailyExerciseGoal(exerciseGoal);
                  Navigator.pop(context);
                },
                child: const Text("Kaydet"),
              ),
            ],
          );
        });
      },
    );
  }
}
