import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unlapse/challenges.dart';

import 'color_schemes.dart';
import 'pages/challenge_page.dart';
import 'pages/progress_page.dart';

const String keyStartDateTime = "start_datetime";

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unlapse',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int challengeId;
  int currentPage = 0;

  void loadNewChallenge() {
    setState(() {
      challengeId = Random().nextInt(challenges.length);
    });
  }

  Future<DateTime> getStartDateTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? startDateTimeString = preferences.getString(keyStartDateTime);

    // Commit the start date time for the first time
    if (startDateTimeString == null) {
      preferences.setString(keyStartDateTime, DateTime.now().toIso8601String());
    }

    return DateTime.parse(startDateTimeString!);
  }

  Future<void> resetTimer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            title: const Text("Do you really want to reset your streak?"),
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("Cancel")),
              OutlinedButton(
                  onPressed: () {
                    preferences.setString(
                        keyStartDateTime, DateTime.now().toIso8601String());
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  child: const Text("Yes"))
            ],
          );
        });
  }

  @override
  void initState() {
    getStartDateTime();
    loadNewChallenge();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Image.asset(
            "assets/icon/unlapse.png",
            width: 50,
          ),
          const Text(
            "Unlapse",
            style: TextStyle(fontFamily: "Cinzel"),
          ),
        ],
      )),
      body: currentPage == 0
          ? ChallengePage(challengeId: challengeId).animate().fadeIn()
          : FutureBuilder(
              future: getStartDateTime(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProgressPage(
                    startDateTime: snapshot.data!,
                  ).animate().fadeIn();
                }
                return Center(child: CircularProgressIndicator());
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: currentPage == 0 ? loadNewChallenge : resetTimer,
        child: currentPage == 0
            ? const Icon(Icons.refresh)
            : const Icon(Icons.soap),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (page) => setState(() {
                currentPage = page;
              }),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.bolt), label: "Challenges"),
            BottomNavigationBarItem(
                icon: Icon(Icons.hourglass_bottom), label: "Progress"),
          ]),
    );
  }
}
