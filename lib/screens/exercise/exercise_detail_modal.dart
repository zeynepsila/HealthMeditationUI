import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';

class ExerciseDetailModal extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExerciseDetailModal({super.key, required this.exercise});

  @override
  State<ExerciseDetailModal> createState() => _ExerciseDetailModalState();
}

class _ExerciseDetailModalState extends State<ExerciseDetailModal> {
  bool isStarted = false;
  int remainingSeconds = 0;
  Timer? _timer;

  void startExercise() {
    final durationText = widget.exercise['duration']; // örnek: "3 dk"
    final minutes = int.tryParse(durationText.toString().split(' ')[0]) ?? 1;

    setState(() {
      isStarted = true;
      remainingSeconds = minutes * 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds == 0) {
        timer.cancel();
        setState(() => isStarted = false);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Lottie.asset('assets/lottie/success.json'),
                    ),
                    const SizedBox(height: 16),
                    const Text("Tebrikler!",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Egzersizi başarıyla tamamladın."),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Kapat"),
                    ),
                  ],
                ),
              ),
            );
          },
        );


      } else {
        setState(() => remainingSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.exercise['title'] ?? 'Egzersiz';
    final duration = widget.exercise['duration'] ?? '';
    final level = widget.exercise['level'] ?? '';
    final description = widget.exercise['description'] ?? '';
    final steps = widget.exercise['steps'] ?? [];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Center(child: Text("$duration • $level")),
              const SizedBox(height: 16),

              if (description.isNotEmpty) ...[
                Text(description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
              ],

              if (steps.isNotEmpty) ...[
                const Text("Nasıl Yapılır?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...List.generate(steps.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ", style: TextStyle(fontSize: 16, color: Colors.teal)),
                        Expanded(
                          child: Text(steps[index], style: const TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],

              Center(
                child: isStarted
                    ? Text(
                  "${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(fontSize: 36),
                )
                    : ElevatedButton.icon(
                  onPressed: startExercise,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Başla"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
