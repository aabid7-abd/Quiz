
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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



class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 40.0,top: 40,left: 25,right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Welcome to the Quiz!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Quiz Rules:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                _buildRuleItem(Icons.format_list_numbered,
                                    'Total Questions:', '10'),
                                const Divider(),
                                _buildRuleItem(Icons.check_circle_outline,
                                    'Correct Answer:', '+4 marks'),
                                const Divider(),
                                _buildRuleItem(Icons.cancel_outlined,
                                    'Wrong Answer:', '-1 mark'),
                                const Divider(),
                                _buildRuleItem(Icons.help_outline,
                                    'Question Types:', 'Multiple Choice'),
                                const Divider(),
                                _buildRuleItem(Icons.timer_outlined,
                                    'Time Limit:', '2 minutes'),
                              ],
                            ),
                          ),
                        ),

                      ],))),
            SizedBox(
              width: double.infinity,
              child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // In StartScreen's ElevatedButton
                onPressed: () {
                  final provider = Provider.of<QuizProvider>(context, listen: false);

                  // Start navigation immediately
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => const QuizScreen(),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Slide from right
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        // const curve = Curves.easeOutBack;
                        // const curve = Curves.fastOutSlowIn;
                        // const curve = Curves.bounceOut;
                        var tween = Tween(begin: begin, end: end).chain(
                          CurveTween(curve: curve),

                        );

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );

                  // Load quiz after navigation
                  Future.microtask(() async {
                    await provider.loadQuiz();
                  });
                },
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.deepPurple),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
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
    if (provider.quiz == null || provider.quiz!.questions.isEmpty) return EmptyQuizScreen();

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
              QuestionProgressIndicator(
                currentIndex: provider.currentQuestionIndex,
                totalQuestions: provider.quiz!.questions.length,
                  skippedQuestions: provider.skippedQuestions,
                  answeredQuestions: provider.answeredQuestions
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

class QuestionProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final Set<int> skippedQuestions; // Track skipped questions
  final Set<int> answeredQuestions; // Track answered questions

  const QuestionProgressIndicator({
    required this.currentIndex,
    required this.totalQuestions,
    required this.skippedQuestions,
    required this.answeredQuestions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalQuestions, (index) {
        // Determine the color based on the question state
        Color circleColor;
        if (index == currentIndex) {
          circleColor = Colors.blue; // Color for the current question
        } else if (skippedQuestions.contains(index)) {
          circleColor = Colors.orange; // Color for skipped questions
        } else if (answeredQuestions.contains(index)) {
          circleColor = Colors.green; // Color for answered questions
        } else {
          circleColor = Colors.grey[300]!; // Color for unanswered questions
        }

        return Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade600),
          ),
        );
      }),
    );
  }
}


class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuizProvider>(context, listen: false);
    provider.stopTimer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final totalQuestions = provider.quiz?.questions.length ?? 0;
    final totalMarks = (provider.correctAnswers * 4) - provider.wrongAnswers;
    final percentage = totalQuestions > 0
        ? (provider.correctAnswers / totalQuestions * 100).round()
        : 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade100, Colors.purple.shade100],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildTrophyAnimation(percentage),
                  const SizedBox(height: 20),
                  _buildScoreCard(percentage),
                  const SizedBox(height: 30),
                  _buildStatsContainer(provider, totalQuestions, totalMarks),
                  const SizedBox(height: 30),
                  _buildActionButtons(context, provider),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrophyAnimation(int percentage) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.0, 0.5),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            )
          ],
        ),
        child: Icon(
          percentage > 70
              ? Icons.emoji_events
              : percentage > 40
              ? Icons.celebration
              : Icons.auto_awesome,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildScoreCard(int percentage) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: percentage / 100),
      duration: const Duration(milliseconds: 1500),
      builder: (context, value, _) {
        return Column(
          children: [
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(percentage),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 10,
                backgroundColor: Colors.grey.shade300,
                color: _getScoreColor(percentage),
                strokeCap: StrokeCap.round,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsContainer(QuizProvider provider, int totalQuestions, int totalMarks) {
    return FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_animationController),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 3,
              )
            ],
          ),
          child:
          Column(
            children: [
              _buildStatRow('Total Questions:', '$totalQuestions'),
              const Divider(),
              _buildStatRow('Attempted Questions:', '${provider.attemptedQuestionsCount}'),
              const Divider(),
              _buildStatRow('Skipped Questions:', '${provider.skippedQuestionsCount}'),
              const Divider(),
              _buildStatRow('Correct Answers:', '${provider.correctAnswers}'),
              const Divider(),
              _buildStatRow('Wrong Answers:', '${provider.wrongAnswers}'),
              const Divider(),
              _buildStatRow('Total Marks:', '$totalMarks', isBold: true),
            ],
          ),

        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, QuizProvider provider) {
    return FadeTransition(
      opacity: _animationController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_animationController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedButton(
              icon: Icons.restart_alt,
              label: 'Restart',
              color: Colors.blue,
              onPressed: () {
                provider.reset();
                Navigator.push(
                  navigatorKey.currentContext!,
                  MaterialPageRoute(builder: (_) => const QuizScreen()),
                );
              },
            ),
            const SizedBox(width: 20),
            _buildAnimatedButton(
              icon: Icons.share,
              label: 'Share',
              color: Colors.green,
              onPressed: () => _shareResults(provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  void _shareResults(QuizProvider provider) {
    final shareText = 'I scored ${provider.correctAnswers * 4 - provider.wrongAnswers} '
        'points in the quiz! 🚀\n'
        'Correct: ${provider.correctAnswers} | Wrong: ${provider.wrongAnswers}';

    Share.share(shareText);
  }
}