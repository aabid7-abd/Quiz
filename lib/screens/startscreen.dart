
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/screens/quizscreen.dart';

import '../statemanage.dart';

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