import 'package:quizapp/models/quiz_model.dart';

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