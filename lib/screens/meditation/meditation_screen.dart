import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import '../../providers/activity_provider.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  int selectedDuration = 1;
  bool isStarted = false;
  int remainingSeconds = 0;
  late AnimationController _controller;
  Animation<double>? _animation;
  Timer? _timer;

  String selectedCategory = "Nefes";

  final List<Map<String, dynamic>> meditationTypes = [
    {
      "title": "Nefes",
      "description": "Nefesine odaklan",
      "instruction": "Burnundan derin nefes al, yavaşça ver...",
      "color": Colors.blueAccent,
    },
    {
      "title": "Farkındalık",
      "description": "Anı hisset",
      "instruction": "Duyularını fark et, şu anda kal...",
      "color": Colors.greenAccent,
    },
    {
      "title": "Uyku Öncesi",
      "description": "Gevşe ve rahatla",
      "instruction": "Gözlerini kapat, vücudunu serbest bırak...",
      "color": Colors.deepPurpleAccent,
    },
  ];

  Color getBackgroundColor() {
    return meditationTypes
        .firstWhere((type) => type["title"] == selectedCategory)["color"];
  }

  String getInstruction() {
    return meditationTypes
        .firstWhere((type) => type["title"] == selectedCategory)["instruction"];
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 100, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void startMeditation() {
    setState(() {
      isStarted = true;
      remainingSeconds = selectedDuration * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        setState(() => isStarted = false);
        _controller.stop();

        Provider.of<ActivityProvider>(context, listen: false)
            .completeMeditation();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/success.json', repeat: false),
                const SizedBox(height: 12),
                const Text("Tebrikler! Meditasyonu tamamladın 🧘‍♀️"),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tamam"),
                )
              ],
            ),
          ),
        );
      } else {
        setState(() => remainingSeconds--);
      }
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final instruction = getInstruction();

    return Scaffold(
      appBar: AppBar(title: const Text("Meditasyon")),
      body: Container(
        color: getBackgroundColor().withOpacity(0.1), // Arka plan burada
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Meditasyon Türü Seç",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: meditationTypes.map((type) {
                    final isSelected = selectedCategory == type["title"];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = type["title"];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? type["color"].withOpacity(0.3)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.teal : Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(type["title"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(type["description"],
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Zihnini Dinlendir",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [1, 5, 10].map((minute) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text("$minute dk"),
                      selected: selectedDuration == minute,
                      onSelected: (selected) {
                        setState(() {
                          selectedDuration = minute;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Center(
                child: isStarted && _animation != null
                    ? AnimatedBuilder(
                  animation: _animation!,
                  builder: (context, child) {
                    return Container(
                      width: _animation!.value,
                      height: _animation!.value,
                      decoration: BoxDecoration(
                        color: getBackgroundColor().withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "Nefes al...",
                          style: TextStyle(
                              color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  },
                )
                    : Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: getBackgroundColor(),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "${selectedDuration.toString().padLeft(2, '0')}:00",
                      style: const TextStyle(
                          fontSize: 36, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  instruction,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: isStarted ? null : startMeditation,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Başla"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(double.infinity, 48),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
