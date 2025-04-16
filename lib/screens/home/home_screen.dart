import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes/app_routes.dart';
import '../../providers/mood_provider.dart';
import '../../providers/activity_provider.dart';
import '../../widgets/weekly_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood;

  final List<String> moods = ["😊", "😐", "😢", "😡", "😴"];
  final List<String> suggestions = [
    "Bugün kendine bir mola ver 🌿",
    "Derin bir nefes al ve gevşe 🧘",
    "Zihnini dinlendirmek senin elinde ☁️",
    "Küçük adımlar da bir yolculuktur 🚶‍♀️",
  ];

  final Map<String, String> moodSuggestions = {
    "😊": "Harika görünüyorsun! Bugün de bu enerjiyi koruyalım ☀️",
    "😐": "Dengeyi bulmak önemli, kısa bir meditasyon iyi gelebilir 🧘‍♂️",
    "😢": "Üzgün hissediyorsan 5 dk nefes egzersizi deneyebilirsin 💙",
    "😡": "Öfke doğaldır. Vücudunu rahatlatacak bir esneme öneririz 🧘‍♀️",
    "😴": "Yorgunsan kısa bir gevşeme molası almayı unutma 🌙",
  };

  @override
  Widget build(BuildContext context) {
    final meditationData = Provider.of<ActivityProvider>(context).getLast7DaysMeditationData();
    final exerciseData = Provider.of<ActivityProvider>(context).getLast7DaysExerciseData();

    final provider = Provider.of<ActivityProvider>(context);
    final meditationProgress = provider.meditationProgress;
    final exerciseProgress = provider.exerciseProgress;
    final String dailySuggestion = (suggestions..shuffle()).first;
    final successDays = provider.successfulDaysThisWeek;
    final successRate = provider.weeklySuccessRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hoş geldin, Zeynep 👋",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text("Bugün nasılsın?", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),

              // Ruh Hali Emojileri
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: moods.map((emoji) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = emoji;
                      });
                      Provider.of<MoodProvider>(context, listen: false).addMood(emoji);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Ruh halin: $emoji olarak kaydedildi")),
                      );
                    },
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  );
                }).toList(),
              ),

              if (selectedMood != null && moodSuggestions[selectedMood!] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            moodSuggestions[selectedMood!]!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.teal),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dailySuggestion,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text("Bugünkü Aktivite", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Meditasyon", "🧘", "${provider.meditationCount} kez"),
                  _buildStatCard("Egzersiz", "🏋️‍♀️", "${provider.exerciseCount} kez"),
                  _buildStatCard(
                    "Ruh Hali",
                    "😊",
                    Provider.of<MoodProvider>(context).moodHistory.isEmpty
                        ? "Yok"
                        : Provider.of<MoodProvider>(context).moodHistory.first['mood'] ?? "❓",
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text("Haftalık Aktivite", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              WeeklyChart(meditationData: meditationData, exerciseData: exerciseData),
              const SizedBox(height: 32),
              Text("Günlük Hedefler", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              _buildProgressBar("Meditasyon", "🧘", meditationProgress, provider.todayMeditationCount, provider.dailyMeditationGoal),
              const SizedBox(height: 12),
              _buildProgressBar("Egzersiz", "🏋️‍♀️", exerciseProgress, provider.todayExerciseCount, provider.dailyExerciseGoal),

              if (meditationProgress >= 1 && exerciseProgress >= 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "🟢 Hedefini geçtin! Harikasın! 🎉",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
                  ),
                )
              else if (meditationProgress >= 1 || exerciseProgress >= 1)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "🟠 Az kaldı! Diğer hedefini de tamamla! 💪",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.orange),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "⚠️ Bugün henüz meditasyon ya da egzersiz yapmadın!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
                  ),
                ),

              const SizedBox(height: 32),
              Text("Haftalık Başarı Özeti", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text("Bu hafta $successDays gün hedefe ulaştın!"),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: successRate,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              if (successDays == 7)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "🏆 Harika! Bu hafta her gün hedefe ulaştın!",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String emoji, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String title, String emoji, double value, int current, int goal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("$emoji $title", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Text("$current / $goal", style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey.shade300,
          color: Colors.teal,
          minHeight: 8,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
