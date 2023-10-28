import 'dart:async';

import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  final DateTime startDateTime;
  const ProgressPage({required this.startDateTime, super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Timer timer;

  String formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return 'Days: $days\nHours: $hours\nMinutes: $minutes\nSeconds: $seconds';
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Duration elapsedTime = DateTime.now().difference(widget.startDateTime);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            formatDuration(elapsedTime),
            style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    offset: const Offset(2.0, 2.0),
                    color: Colors.amber.withAlpha(100),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
