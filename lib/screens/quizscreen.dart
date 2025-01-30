import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../statemanage.dart';
import 'Erron handling.dart';
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    // Start timer when the screen loads
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.startTimer();
  }

  @override
  void dispose() {
    // Stop timer when the screen is disposed
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context, listen: true);
    final theme = Theme.of(context);

    // Handle loading, error, and empty states
    if (provider.isLoading) return const LoadingScreen();
    if (provider.errorMessage != null) return ErrorScreen(message: provider.errorMessage!);
    if (provider.quiz == null || provider.quiz!.questions.isEmpty) return const EmptyQuizScreen();

    final question = provider.quiz!.questions[provider.currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question ${provider.currentQuestionIndex + 1}/${provider.quiz!.questions.length}',
          style: theme.textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          // Timer display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  provider.formatTime(provider.timeLeft),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: provider.timeLeft <= 10 ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(provider.quiz!.questions.length, (index) {
                  // Get state from provider
                  final isCurrent = index == provider.currentQuestionIndex;
                  final isAnswered = provider.answeredQuestions.contains(index);
                  final isSkipped = provider.skippedQuestions.contains(index);

                  // Determine circle color
                  final Color circleColor = isCurrent
                      ? Colors.blue
                      : isSkipped
                      ? Colors.orange
                      : isAnswered
                      ? Colors.green
                      : Colors.grey[300]!;

                  return Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent ? Colors.blue.shade800 : Colors.grey.shade600,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                  );
                }),
              ),


              const SizedBox(height: 32),

              // Question Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Number
                      Text(
                        'Question ${provider.currentQuestionIndex + 1}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Question Text
                      Text(
                        question.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.9,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options List
              Expanded(
                flex: 2,
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  physics: const BouncingScrollPhysics(),
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    int i = index + 1;
                    return OptionButton(
                      text: '$i: ${option.description}',
                      isCorrect: index == question.correctAnswerIndex,
                      isSelected: provider.isAnswered,
                      onTap: () => provider.answerQuestion(index),
                    );
                  },
                ),
              ),

              // Skip Button

            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(

        width: 150,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: provider.skipQuestion,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.skip_next,color: Colors.white,),
              Text('Skip Question',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
            ],
          ),
        ),
      ),
    );
  }
}
class OptionButton extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({super.key,
    required this.text,
    required this.isCorrect,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color backgroundColor = theme.cardColor;
    Color textColor = theme.textTheme.bodyLarge!.color!;

    if (isSelected) {
      backgroundColor = isCorrect ? Colors.green : Colors.red;
      textColor = Colors.white;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: isSelected ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
