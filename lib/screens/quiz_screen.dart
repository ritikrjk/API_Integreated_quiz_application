import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_test/question.dart';
import 'package:http/http.dart' as http;

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> ques = [];
  int currentQuestionIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the API when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 152, 150, 150),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 56, 57, 58),
        foregroundColor: Colors.white,
        title: const Text(
          "Quiz Screen",
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            _questionWidget(),
            _options(),
            _nextButton(),
            _scoreCard()
          ],
        ),
      ),
    );
  }

  Widget _questionWidget() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: 25)),
        Text(
          "${currentQuestionIndex + 1}" "/ ${ques.length}",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 206, 198, 123),
              borderRadius: BorderRadius.circular(15)),
          child: Text(
            ques.length == 0 ? "Empty" : ques[currentQuestionIndex].question,
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }

  Widget _options() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (ques[currentQuestionIndex].rightAns == 'True') {
                score++;
              }
            },
            child: const Text("True"),
          ),
          SizedBox(
            width: 40,
          ),
          ElevatedButton(
              onPressed: () {
                if (ques[currentQuestionIndex].rightAns == 'False') {
                  score++;
                }
              },
              child: const Text("False")),
        ],
      ),
    );
  }

  fetchData() async {
    const url = 'https://opentdb.com/api.php?amount=10&type=boolean';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;
    final transformed = results.map((e) {
      return Question(question: e['question'], rightAns: e['correct_answer']);
    }).toList();

    setState(() {
      ques = transformed;
    });
  }

  _nextButton() {
    bool lastQues = currentQuestionIndex == ques.length - 1 ? true : false;
    return ElevatedButton(
        onPressed: () {
          if (lastQues) {
            setState(() {
              currentQuestionIndex = 0;
              score = 0;
            });
          } else {
            setState(() {
              currentQuestionIndex++;
            });
          }
        },
        child: lastQues ? const Text("Restart") : Icon(Icons.skip_next));
  }

  _scoreCard() {
    return Container(
      margin: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.orange,
      ),
      child: Row(
        children: [
          Padding(padding: EdgeInsets.all(50)),
          Text(
            "Score : $score",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  //   _scoreCard() {
  //   return AlertDialog(
  //     title: Text("Score: $score"),
  //     content: ElevatedButton(
  //       child: Icon(Icons.refresh),
  //       onPressed: () {
  //         setState(() {
  //           currentQuestionIndex = 0;
  //           score = 0;
  //         });
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }
}
