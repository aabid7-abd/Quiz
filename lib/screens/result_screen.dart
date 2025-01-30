
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/screens/quiz_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';
import '../state_manage/quiz_provider.dart';
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