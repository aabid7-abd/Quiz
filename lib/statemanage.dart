import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizapp/screens/resultscreen.dart';

import 'Model/quiz.dart';
import 'main.dart';

class QuizProvider extends ChangeNotifier {
  Quiz? _quiz;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _errorMessage;
  int _timeLeft = 120;
  Timer? _timer;
  final Set<int> _attemptedQuestions = {};
  final Set<int> _skippedQuestions = {};
  bool _isLoading = false;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  // Getters
  Quiz? get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isAnswered => _isAnswered;
  String? get errorMessage => _errorMessage;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  int get timeLeft => _timeLeft;
  int get attemptedQuestionsCount => _attemptedQuestions.length;
  int get skippedQuestionsCount => _skippedQuestions.length;
  bool get isLoading => _isLoading;
  Set<int> get skippedQuestions => _skippedQuestions;
  final Set<int> _answeredQuestions = {}; // Track answered questions

  Set<int> get answeredQuestions => _answeredQuestions;

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


  void answerQuestion(int selectedIndex) {
    _attemptedQuestions.add(_currentQuestionIndex);
    _answeredQuestions.add(_currentQuestionIndex);
    _isAnswered = true;
    final question = _quiz!.questions[_currentQuestionIndex];

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

  // Reset all data
  void reset() {
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _isAnswered = false;
    _timeLeft = 120;
    _attemptedQuestions.clear();
    _skippedQuestions.clear();
    _answeredQuestions.clear();
    stopTimer();
    notifyListeners();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else {
        endQuiz();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void endQuiz() {
    stopTimer();
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const ResultScreen()),
    );
  }

  void skipQuestion() {
    _skippedQuestions.add(_currentQuestionIndex);
    nextQuestion();
    notifyListeners();

  }
  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '$minutes:${sec.toString().padLeft(2, '0')}';
  }

}