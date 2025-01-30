import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quizapp/models/question_model.dart';


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