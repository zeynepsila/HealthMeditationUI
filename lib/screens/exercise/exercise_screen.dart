import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activity_provider.dart';
import 'exercise_detail_modal.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {
        "title": "Yoga",
        "icon": Icons.self_improvement,
        "duration": "1 dk",
        "level": "Başlangıç",
        "description": "Yoga, vücut ve zihin uyumunu sağlamak için nefes ve duruşların birleşiminden oluşur. Kasları esnetirken zihni de sakinleştirir.",
        "steps": [
          "Rahat bir pozisyonda otur.",
          "Gözlerini kapat ve nefesini hisset.",
          "Vücudunu öne doğru eğerek esnet.",
          "Kollarını yukarı uzat, derin nefes al.",
          "5 dakika boyunca pozisyonları tekrarla."
        ]
      },
      {
        "title": "Esneme",
        "icon": Icons.accessibility_new,
        "duration": "5 dk",
        "level": "Orta",
        "description": "Esneme hareketleri, kasların gevşemesine ve eklem hareket açıklığının artmasına yardımcı olur.",
        "steps": [
          "Kollarını yana doğru aç.",
          "Boynunu sağa ve sola hafifçe eğ.",
          "Kollarını yukarı kaldır ve geriye doğru esnet.",
          "Bacaklarını ileri uzat, parmak uçlarına dokunmaya çalış.",
          "Her hareketi 30 saniye boyunca sürdür."
        ]
      },
      {
        "title": "Nefes Egzersizi",
        "icon": Icons.air,
        "duration": "3 dk",
        "level": "Tüm Seviyeler",
        "description": "Nefes egzersizleri, stresi azaltmak ve odaklanmayı artırmak için güçlü bir yöntemdir.",
        "steps": [
          "Dik otur, gözlerini kapat.",
          "4 saniye boyunca burnundan nefes al.",
          "4 saniye nefesini tut.",
          "4 saniyede yavaşça ver.",
          "Bu döngüyü 10 kez tekrarla."
        ]
      },
      {
        "title": "Plank",
        "icon": Icons.fitness_center,
        "duration": "3 dk",
        "level": "İleri",
        "description": "Plank egzersizi, karın ve sırt kaslarını güçlendirir. Duruşu iyileştirir ve dengeyi artırır.",
        "steps": [
          "Mat üzerinde yüzüstü uzan.",
          "Dirseklerini omuz hizasında konumlandır.",
          "Vücudunu düz bir çizgi haline getir.",
          "Karın kaslarını sık ve nefes almayı unutma.",
          "Pozisyonu 30 saniye ile başlat, ilerledikçe artır."
        ]
      },
    ];

    Map<String, List<Map<String, dynamic>>> groupedExercises = {};

    for (var ex in exercises) {
      final level = ex['level'] ?? 'Genel';
      groupedExercises.putIfAbsent(level, () => []).add(ex);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Egzersizler")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children:
            groupedExercises.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...entry.value
                      .map((item) => _buildExerciseCard(context, item))
                      .toList(),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.teal.shade50,
      child: ListTile(
        leading: Icon(item["icon"], size: 36, color: Colors.teal),
        title: Text(
          item["title"],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text("${item["duration"]} • ${item["level"]}"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              isScrollControlled: true,
              builder: (context) {
                return ExerciseDetailModal(exercise: item);
              },
            );
          },
      ),
    );
  }
}
