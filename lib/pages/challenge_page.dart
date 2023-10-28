import 'package:flutter/material.dart';
import 'package:unlapse/challenges.dart';

class ChallengePage extends StatelessWidget {
  final int challengeId;
  const ChallengePage({required this.challengeId, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            challenges[challengeId].title,
            style: TextStyle(
                fontFamily: "Cinzel",
                fontSize: 30,
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
          const SizedBox(
            height: 26,
          ),
          Text(
            challenges[challengeId].description,
            style: const TextStyle(fontFamily: "Fauna One", fontSize: 20),
          ),
        ],
      ),
    );
  }
}
