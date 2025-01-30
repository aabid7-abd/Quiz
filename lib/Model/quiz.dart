import 'dart:convert';

import 'package:http/http.dart' as http;


class Quiz {
  final List<Question> questions;
  Quiz({required this.questions});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questions = (json['questions'] as List)
        .map((q) => Question.fromJson(q))
        .toList();
    return Quiz(questions: questions);
  }
}

class Question {
  final String description;
  final List<Option> options;
  final int correctAnswerIndex;

  Question({
    required this.description,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List)
        .map((o) => Option.fromJson(o))
        .toList();

    final correctIndex = options.indexWhere((o) => o.isCorrect);

    return Question(
      description: json['description'],
      options: options,
      correctAnswerIndex: correctIndex,
    );
  }
}

class Option {
  final String description;
  final bool isCorrect;

  Option({required this.description, required this.isCorrect});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      description: json['description'],
      isCorrect: json['is_correct'],
    );
  }
}
class QuizService {
  Future<Quiz> fetchQuiz() async {
    final response = await http.get(Uri.parse('https://api.jsonserve.com/Uw5CrX'));
    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load quiz');
    }
  }
}