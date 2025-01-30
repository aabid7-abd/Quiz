import 'dart:async';

import 'package:flutter/material.dart';

import 'Model/quiz.dart';
import 'main.dart';

class QuizProvider extends ChangeNotifier {
  Quiz? _quiz;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _errorMessage;
  int _questionsAttempted = 0; // New variable to track attempted questions

  // Getters
  Quiz? get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isAnswered => _isAnswered;
  String? get errorMessage => _errorMessage;

  int get questionsAttempted => _questionsAttempted; // Getter for attempted questions

  bool _isLoading = false;


  bool get isLoading => _isLoading;

  Future<void> loadQuiz() async {
    _isLoading = true;
    notifyListeners();

    try {
      _quiz = await QuizService().fetchQuiz();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load quiz: ${e.toString()}";
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void nextQuestion() {
    if (_currentQuestionIndex < _quiz!.questions.length - 1) {
      _currentQuestionIndex++;
      _isAnswered = false;
      notifyListeners();
    } else {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const ResultScreen()),
      );
    }
  }
  void endQuiz() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const ResultScreen()),
    );
  }

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;

  void answerQuestion(int selectedIndex) {
    _isAnswered = true;
    final question = _quiz!.questions[_currentQuestionIndex];
    _questionsAttempted++; // Increment attempted questions count
    if (selectedIndex == question.correctAnswerIndex) {
      _score += 4;
      _correctAnswers++;
    } else {
      _score -= 1;
      _wrongAnswers++;
    }

    notifyListeners();
    Future.delayed(const Duration(seconds: 1), nextQuestion);
  }

  void reset() {
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _isAnswered = false;
    _questionsAttempted = 0; // Reset the attempted questions count
    _remainingTime = 120;
    startTimer();
    notifyListeners();
  }


  late Timer _timer;
  int _remainingTime = 120;
  int get remainingTime => _remainingTime;
  Timer get timer => _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
          _remainingTime--;
       notifyListeners();
      } else {
        _timer.cancel();
        endQuiz(); // Auto-submit quiz when timer ends
        notifyListeners();
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
  }

  void skipQuestion() {
    // _questionsAttempted++; // Increment attempted questions count
    // _isAnswered = true; // Mark it as answered to prevent multiple taps

    notifyListeners();
    Future.delayed(const Duration(seconds: 1), nextQuestion);
  }

}