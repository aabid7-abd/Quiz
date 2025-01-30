
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/screens/quizscreen.dart';
import 'package:quizapp/screens/startscreen.dart';
import 'package:quizapp/statemanage.dart';
import 'package:share_plus/share_plus.dart';
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  final quizProvider = QuizProvider();
  runApp(
    ChangeNotifierProvider(
      create: (_) => quizProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const StartScreen(),
    );
  }
}




