import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Model/quiz.dart';
import 'main.dart';

class QuizProvider extends ChangeNotifier {
  Quiz? _quiz;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _errorMessage;

  // Getters
  Quiz? get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isAnswered => _isAnswered;
  String? get errorMessage => _errorMessage;


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
        MaterialPageRoute(builder: (_) => ResultScreen()),
      );
    }
  }


  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;

  void answerQuestion(int selectedIndex) {
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
    Future.delayed(Duration(seconds: 1), nextQuestion);
  }

  void reset() {
    _currentQuestionIndex = 0;
    _score = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _isAnswered = false;
    notifyListeners();
  }
}