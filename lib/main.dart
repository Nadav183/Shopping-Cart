import 'package:flutter/material.dart';

import './question.dart';
import './answer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var questions = ['How are you?', 'Are you hungry?','???'];

  void _answerQuestion(num) {
    print("You chose $num!");
    if (_questionIndex == questions.length-1) {
      setState(() => _questionIndex = 0);
    }
    else
      setState(() => _questionIndex++);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      appBar: AppBar(title: Text('My App'),),
      body: Column(children: <Widget>[
        Question(questions[_questionIndex]),
        Answer('Option1'),
        Answer('Option2'),
        Answer('Option3'),
      ],
      ),
    ));
  }
}