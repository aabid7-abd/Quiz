import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../statemanage.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Preparing your quiz...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This might take a moment',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;

  ErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error loading quiz:", style: TextStyle(color: Colors.red)),
            Text(message),
            ElevatedButton(
              onPressed: () => Provider.of<QuizProvider>(context, listen: false).loadQuiz(),
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyQuizScreen extends StatelessWidget {
  const EmptyQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No questions available in this quiz"),
      ),
    );
  }
}
