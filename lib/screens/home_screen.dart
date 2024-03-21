import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_api_test/question.dart';
import 'package:flutter_api_test/screens/quiz_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> ques = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("API TESTING"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: ques.length,
          itemBuilder: (context, index) {
            final que = ques[index];
            final ans = que.rightAns;
            return ListTile(
              title: Text(ques[index].question),
              subtitle: Text(que.rightAns.toString()),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => fetchData(),
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const QuizScreen()));
    });
  }
}
