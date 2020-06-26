import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String questionText;
  final Function func;
  final String value;

  Answer(this.questionText, this.func, this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child:RaisedButton(
        child: Text('Answer: '+questionText),
        onPressed: () => func(value),
        color: Colors.blue,
      ),
    );
  }
}
