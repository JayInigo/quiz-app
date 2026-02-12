import 'package:flutter/material.dart';
import 'dart:math'; // Importing the math library for random number generation

// Main entry point of the Flutter application
void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App', // App title shown in task switcher
      debugShowCheckedModeBanner: false, // Hides the debug banner in top-right corner
      theme: ThemeData(
        primarySwatch: Colors.teal, // Sets the primary color scheme
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Default background color
        useMaterial3: true, // Enables Material Design 3
      ),
      home: const QuizWidget(), // Sets the home screen widget
    );
  }
}

// Stateful widget for the quiz functionality
class QuizWidget extends StatefulWidget {
  const QuizWidget({super.key});

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

// State class for QuizWidget with animation support
class _QuizWidgetState extends State<QuizWidget> with SingleTickerProviderStateMixin {
  // State variables
  bool quizStarted = false; // Tracks whether the quiz has started
  int currentQuestionIndex = 0; // Current question being displayed
  int score = 0; // User's current score
  bool answerSelected = false; // Whether user has selected an answer for current question
  int? selectedAnswerIndex; // Index of the selected answer (null if none selected)
  List<Map<String, dynamic>> shuffledQuestions = []; // Questions in randomized order
  List<Map<String, dynamic>> userAnswers = []; // Store user's answers for review
  late AnimationController _animationController; // Controls fade animations
  late Animation<double> _fadeAnimation; // Animation for fading in questions
  String username = ''; // Store the username


  // List of quiz questions with answers, correct answer index, and explanations
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Which feature would help BIGGS branches in Naga City manage customer flow during peak hours?',
      'answers': [
        'Digital queue number system with estimated wait time',
        'Pre-order and scheduled pickup system',
        'Table reservation with real-time availability',
        'Customer feedback and rating system'
      ],
      'correctAnswer': 0, // Index of the correct answer (0-based)
      'explanation': 'A digital queue number system helps manage crowds by letting customers see their position in line and estimated wait time on their phones, reducing congestion at the counter.',
    },
    {
      'question': "What mobile app feature would most benefit Mercury Drug stores in Naga City?",
      'answers': [
        'Prescription refill reminders and online ordering',
        'Medicine inventory checker across branches',
        'Senior citizen discount card registration',
        'Pharmacist consultation booking system'
      ],
      'correctAnswer': 1,
      'explanation': 'An inventory checker lets customers find out which branch has their needed medicine in stock before traveling, saving time and effort.',
    },
    {
      'question': 'Which feature would help Tropical Hut Hamburger in Cubao, Naga City improve their service?',
      'answers': [
        'Loyalty points and digital stamp card',
        'Advance ordering for takeout/delivery',
        'Menu item availability updates',
        'Group order and party reservation system'
      ],
      'correctAnswer': 1,
      'explanation': 'Advance ordering allows customers to place orders ahead of time and pick up their food ready, reducing wait time during busy hours.',
    },
    {
      'question': 'What would help barangay health centers in Naga City serve residents better?',
      'answers': [
        'Vaccination appointment scheduling',
        'Health record access and document requests',
        'Medicine availability notifications',
        'Online health consultation queue system'
      ],
      'correctAnswer': 0,
      'explanation': 'An appointment scheduling system prevents long queues and overcrowding by organizing vaccination schedules, especially important during health campaigns.',
    },
    {
      'question': 'Which feature would benefit LBC Express branches in Naga City the most?',
      'answers': [
        'Real-time package tracking with GPS',
        'Pickup request scheduling from home',
        'Branch queue number and estimated service time',
        'Shipping rate calculator and comparison tool'
      ],
      'correctAnswer': 2,
      'explanation': 'A queue number system with wait time helps customers avoid long lines at the branch by checking how busy it is before going there.',
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controller with 500ms duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this, // Provides ticker for animation
    );
    // Create fade animation from 0 (transparent) to 1 (opaque)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up animation controller to prevent memory leaks
    super.dispose();
  }

  // Function to start/restart the quiz
  void startQuiz(String name) {
    setState(() {
      username = name;
      shuffledQuestions = List.from(questions)..shuffle(Random()); // Create shuffled copy of questions
      quizStarted = true;
      currentQuestionIndex = 0;
      score = 0;
      answerSelected = false;
      selectedAnswerIndex = null;
      userAnswers = []; // Reset user answers
    });
    _animationController.forward(from: 0.0); // Start fade-in animation
  }

  // Function called when user selects an answer
  void selectAnswer(int answerIndex) {
    if (answerSelected) return; // Prevent selecting multiple answers
    
    final isCorrect = answerIndex == shuffledQuestions[currentQuestionIndex]['correctAnswer'];
    
    setState(() {
      selectedAnswerIndex = answerIndex;
      answerSelected = true;
      // Check if selected answer is correct and increment score
      if (isCorrect) {
        score++;
      }
      
      // Store the user's answer for review
      userAnswers.add({
        'question': shuffledQuestions[currentQuestionIndex]['question'],
        'answers': shuffledQuestions[currentQuestionIndex]['answers'],
        'correctAnswer': shuffledQuestions[currentQuestionIndex]['correctAnswer'],
        'userAnswer': answerIndex,
        'explanation': shuffledQuestions[currentQuestionIndex]['explanation'],
        'isCorrect': isCorrect,
      });
    });
  }

  // Function to move to next question or end quiz
  void nextQuestion() {
    if (currentQuestionIndex < shuffledQuestions.length - 1) {
      // More questions remaining
      setState(() {
        currentQuestionIndex++;
        answerSelected = false;
        selectedAnswerIndex = null;
      });
      _animationController.forward(from: 0.0); // Animate next question
    } else {
      // Quiz completed
      setState(() {
        quizStarted = false;
      });
    }
  }

  // Function to reset quiz to initial state
  void restartQuiz() {
    setState(() {
      quizStarted = false;
      currentQuestionIndex = 0;
      score = 0;
      answerSelected = false;
      selectedAnswerIndex = null;
      username = '';
      userAnswers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient background decoration
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A5F6B), // Dark teal (top)
              Color(0xFF4A9BA5), // Teal
              Color(0xFF88C5CC), // Medium cyan
              Color(0xFFE8F4F8), // Light cyan (bottom)
            ],
          ),
        ),
        child: SafeArea( // Ensures content doesn't overlap with system UI
          // Conditional rendering based on quiz state
          child: !quizStarted && score == 0
              ? StartView(onStart: startQuiz, totalQuestions: questions.length) // Show start screen
              : quizStarted
                  ? QuizView( // Show quiz questions
                      currentQuestion: shuffledQuestions[currentQuestionIndex],
                      currentIndex: currentQuestionIndex,
                      totalQuestions: shuffledQuestions.length,
                      score: score,
                      answerSelected: answerSelected,
                      selectedAnswerIndex: selectedAnswerIndex,
                      fadeAnimation: _fadeAnimation,
                      onAnswerSelected: selectAnswer,
                      onNext: nextQuestion,
                    )
                  : EndView( // Show results screen
                      score: score,
                      totalQuestions: shuffledQuestions.length,
                      username: username,
                      userAnswers: userAnswers,
                      onRestart: restartQuiz,
                    ),
        ),
      ),
    );
  }
}

// ==================== Start View ====================
// Widget displayed at the beginning of the quiz
class StartView extends StatefulWidget {
  final Function(String) onStart; // Callback function when enter button is pressed
  final int totalQuestions; // Total number of questions in the quiz

  const StartView({
    super.key,
    required this.onStart,
    required this.totalQuestions,
  });

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  final TextEditingController _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _handleStart() {
    if (_formKey.currentState!.validate()) {
      widget.onStart(_usernameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // BizQuiz circle with gradient highlight
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2A7A88), // Darker teal
                      Color(0xFF1A5F6B), // Deep teal
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF5DD9E8).withValues(alpha: 0.7), // Bright Aqua glow
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                    BoxShadow(
                      color: Color(0xFF9FE8F0).withValues(alpha: 0.5), // Light Cyan accent
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'BizQuiz',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: Color(0xFF5DD9E8).withValues(alpha: 0.8),
                          blurRadius: 20,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Color(0xFF9FE8F0).withValues(alpha: 0.6),
                          blurRadius: 30,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Question count display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${widget.totalQuestions} Business Questions',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Username input field
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A5F6B), // Dark teal
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Color(0xFF1A5F6B), // Dark teal
                      size: 26,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleStart(),
                ),
              ),
              const SizedBox(height: 24),
              // Enter button
              ElevatedButton(
                onPressed: _handleStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xFF1A5F6B), // Dark teal
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                  elevation: 8,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward_rounded, size: 28),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== Quiz View ====================
// Main quiz screen showing question and answers
class QuizView extends StatelessWidget {
  final Map<String, dynamic> currentQuestion; // Current question data
  final int currentIndex; // Current question number
  final int totalQuestions; // Total questions in quiz
  final int score; // Current score
  final bool answerSelected; // Whether an answer has been selected
  final int? selectedAnswerIndex; // Which answer was selected
  final Animation<double> fadeAnimation; // Fade animation
  final Function(int) onAnswerSelected; // Callback when answer is selected
  final VoidCallback onNext; // Callback for next button

  const QuizView({
    super.key,
    required this.currentQuestion,
    required this.currentIndex,
    required this.totalQuestions,
    required this.score,
    required this.answerSelected,
    required this.selectedAnswerIndex,
    required this.fadeAnimation,
    required this.onAnswerSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        children: [
          // Header showing progress and score
          QuizHeader(
            currentIndex: currentIndex,
            totalQuestions: totalQuestions,
            score: score,
          ),
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Question and answer options
                  QuestionCard(
                    question: currentQuestion['question'],
                    answers: currentQuestion['answers'],
                    correctAnswer: currentQuestion['correctAnswer'],
                    explanation: currentQuestion['explanation'],
                    selectedAnswerIndex: selectedAnswerIndex,
                    answerSelected: answerSelected,
                    onAnswerSelected: onAnswerSelected,
                  ),
                  // Show next button only after answer is selected
                  if (answerSelected) ...[
                    const SizedBox(height: 20),
                    NextButton(
                      onPressed: onNext,
                      isLastQuestion: currentIndex >= totalQuestions - 1,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Quiz Header ====================
// Header showing question progress and current score
class QuizHeader extends StatelessWidget {
  final int currentIndex; // Current question index
  final int totalQuestions; // Total number of questions
  final int score; // Current score

  const QuizHeader({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Question number indicator
              _InfoChip(
                icon: Icons.help_outline,
                text: 'Question ${currentIndex + 1}/$totalQuestions',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar showing quiz completion
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentIndex + 1) / totalQuestions, // Progress percentage
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// Info chip widget for displaying question number and score
class _InfoChip extends StatelessWidget {
  final IconData icon; // Icon to display
  final String text; // Text to display

  const _InfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Question Card ====================
// Card displaying the question, answer options, and explanation
class QuestionCard extends StatelessWidget {
  final String question; // Question text
  final List<dynamic> answers; // List of answer options
  final int correctAnswer; // Index of correct answer
  final String explanation; // Explanation for the answer
  final int? selectedAnswerIndex; // Selected answer index
  final bool answerSelected; // Whether answer has been selected
  final Function(int) onAnswerSelected; // Callback for answer selection

  const QuestionCard({
    super.key,
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.explanation,
    required this.selectedAnswerIndex,
    required this.answerSelected,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Question text
          Text(
            question,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A5F6B), // Dark teal
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Generate answer options dynamically
          ...List.generate(
            answers.length,
            (index) => AnswerOption(
              index: index,
              answer: answers[index],
              isCorrect: index == correctAnswer,
              isSelected: selectedAnswerIndex == index,
              answerSelected: answerSelected,
              onTap: () => onAnswerSelected(index),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Answer Option ====================
// Individual answer option button
class AnswerOption extends StatelessWidget {
  final int index; // Answer index (0, 1, 2, 3)
  final String answer; // Answer text
  final bool isCorrect; // Whether this is the correct answer
  final bool isSelected; // Whether this answer was selected
  final bool answerSelected; // Whether any answer has been selected
  final VoidCallback onTap; // Callback when tapped

  const AnswerOption({
    super.key,
    required this.index,
    required this.answer,
    required this.isCorrect,
    required this.isSelected,
    required this.answerSelected,
    required this.onTap,
  });

  // Determines background color based on selection state
  Color _getBackgroundColor() {
    if (isSelected) {
      return Color(0xFF88C5CC).withValues(alpha: 0.3); // Light teal
    }
    return Colors.grey.shade100; // Default background
  }

  // Determines border color based on selection state
  Color _getBorderColor() {
    if (isSelected) return Color(0xFF1A5F6B); // Dark teal
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        elevation: isSelected ? 8 : 2, // Higher elevation when selected
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: answerSelected ? null : onTap, // Disable tap after answer selected
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: _getBackgroundColor(),
              border: Border.all(color: _getBorderColor(), width: 2),
            ),
            child: Row(
              children: [
                // Letter indicator (A, B, C, D)
                _OptionCircle(
                  index: index,
                  isSelected: isSelected,
                  isCorrect: isCorrect,
                  answerSelected: answerSelected,
                ),
                const SizedBox(width: 14),
                // Answer text
                Expanded(
                  child: Text(
                    answer,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Color(0xFF1A5F6B) : Colors.black87, // Dark teal when selected
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Circle with letter (A, B, C, D) for each answer option
class _OptionCircle extends StatelessWidget {
  final int index; // Answer index
  final bool isSelected; // Selected state
  final bool isCorrect; // Correct answer state
  final bool answerSelected; // Any answer selected state

  const _OptionCircle({
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.answerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Color(0xFF1A5F6B) : Color(0xFF88C5CC).withValues(alpha: 0.4), // Dark teal / Light teal
      ),
      child: Center(
        child: Text(
          String.fromCharCode(65 + index), // Convert 0->A, 1->B, 2->C, 3->D
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected ? Colors.white : Color(0xFF1A5F6B), // White / Dark teal
          ),
        ),
      ),
    );
  }
}

// ==================== Explanation Box ====================
// Box showing explanation after answer is selected
class ExplanationBox extends StatelessWidget {
  final String explanation; // Explanation text

  const ExplanationBox({super.key, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_rounded, color: Colors.blue.shade700, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              explanation,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Next Button ====================
// Button to move to next question or view results
class NextButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback when pressed
  final bool isLastQuestion; // Whether this is the last question

  const NextButton({
    super.key,
    required this.onPressed,
    required this.isLastQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A5F6B), // Dark teal
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 6,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Change text based on whether it's the last question
          Text(
            isLastQuestion ? 'See Results' : 'Next Question',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          // Change icon based on whether it's the last question
          Icon(isLastQuestion ? Icons.emoji_events_rounded : Icons.arrow_forward_rounded),
        ],
      ),
    );
  }
}

// ==================== End View ====================
// Final screen showing quiz results with detailed breakdown
class EndView extends StatelessWidget {
  final int score; // Final score
  final int totalQuestions; // Total questions
  final String username; // Username
  final List<Map<String, dynamic>> userAnswers; // User's answers for review
  final VoidCallback onRestart; // Callback to restart quiz

  const EndView({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.username,
    required this.userAnswers,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round(); // Calculate percentage
    final resultData = _getResultData(percentage); // Get emoji and message based on score

    return Column(
      children: [
        // Header with back to top button
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quiz Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Results summary card
                Text(resultData['emoji']!, style: const TextStyle(fontSize: 100)),
                const SizedBox(height: 20),
                Text(
                  resultData['message']!,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                if (username.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                ScoreCard(score: score, totalQuestions: totalQuestions, percentage: percentage),
                
                const SizedBox(height: 40),
                
                // Performance insights
                PerformanceInsights(score: score, totalQuestions: totalQuestions, percentage: percentage),
                
                const SizedBox(height: 40),
                
                // Detailed question review
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics_rounded, color: Color(0xFF1A5F6B), size: 28), // Dark teal
                          const SizedBox(width: 12),
                          const Text(
                            'Detailed Review',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A5F6B), // Dark teal
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...List.generate(
                        userAnswers.length,
                        (index) => QuestionReviewCard(
                          questionNumber: index + 1,
                          questionData: userAnswers[index],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
                RestartButton(onPressed: onRestart),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Determines emoji and message based on score percentage
  Map<String, String> _getResultData(int percentage) {
    if (percentage >= 80) {
      return {'emoji': '🏆', 'message': 'Excellent!'};
    } else if (percentage >= 60) {
      return {'emoji': '🥈', 'message': 'Good Job!'};
    } else if (percentage >= 40) {
      return {'emoji': '🥉', 'message': 'Not Bad!'};
    }
    return {'emoji': '🏅', 'message': 'Keep Trying!'};
  }
}

// ==================== Performance Insights ====================
// Widget showing performance statistics and insights
class PerformanceInsights extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int percentage;

  const PerformanceInsights({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final incorrectAnswers = totalQuestions - score;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.insights_rounded, color: Color(0xFF1A5F6B), size: 28), // Dark teal
              const SizedBox(width: 12),
              const Text(
                'Performance Insights',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A5F6B), // Dark teal
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _InsightCard(
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                  label: 'Correct',
                  value: '$score',
                  backgroundColor: Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InsightCard(
                  icon: Icons.cancel_rounded,
                  iconColor: Colors.red,
                  label: 'Incorrect',
                  value: '$incorrectAnswers',
                  backgroundColor: Colors.red.shade50,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InsightCard(
            icon: Icons.trending_up_rounded,
            iconColor: Colors.blue,
            label: 'Accuracy Rate',
            value: '$percentage%',
            backgroundColor: Colors.blue.shade50,
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color backgroundColor;

  const _InsightCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 36),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Question Review Card ====================
// Card showing individual question review with user's answer and correct answer
class QuestionReviewCard extends StatelessWidget {
  final int questionNumber;
  final Map<String, dynamic> questionData;

  const QuestionReviewCard({
    super.key,
    required this.questionNumber,
    required this.questionData,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = questionData['isCorrect'];
    final int userAnswer = questionData['userAnswer'];
    final int correctAnswer = questionData['correctAnswer'];
    final List answers = questionData['answers'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question number and result indicator
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF1A5F6B), // Dark teal
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Q$questionNumber',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct' : 'Incorrect',
                style: TextStyle(
                  color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Question text
          Text(
            questionData['question'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // User's answer
          _AnswerDisplay(
            label: 'Your Answer',
            answer: answers[userAnswer],
            isCorrect: isCorrect,
            showIcon: true,
          ),
          // Show correct answer if user was wrong
          if (!isCorrect) ...[
            const SizedBox(height: 12),
            _AnswerDisplay(
              label: 'Correct Answer',
              answer: answers[correctAnswer],
              isCorrect: true,
              showIcon: true,
            ),
          ],
          const SizedBox(height: 16),
          // Explanation
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_rounded, color: Colors.amber.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    questionData['explanation'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerDisplay extends StatelessWidget {
  final String label;
  final String answer;
  final bool isCorrect;
  final bool showIcon;

  const _AnswerDisplay({
    required this.label,
    required this.answer,
    required this.isCorrect,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect ? Colors.green.shade300 : Colors.red.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              if (showIcon) ...[
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== Score Card ====================
// Card displaying final score with percentage
class ScoreCard extends StatelessWidget {
  final int score; // User's score
  final int totalQuestions; // Total questions
  final int percentage; // Score percentage

  const ScoreCard({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // "Your Score" label
          const Text(
            'Your Score',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 24),
          // Score display (e.g., "4 / 5")
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A5F6B), // Dark teal
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  ' / $totalQuestions',
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Percentage display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF88C5CC).withValues(alpha: 0.3), // Light teal background
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A5F6B), // Dark teal
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Restart Button ====================
// Button to restart the quiz
class RestartButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback when pressed

  const RestartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh_rounded, size: 30),
      label: const Text(
        'Try Again',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A5F6B), // Dark teal
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        elevation: 8,
      ),
    );
  }
}