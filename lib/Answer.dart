import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String questionText;

  Answer(this.questionText);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child:RaisedButton(
        child: Text('Question: '+questionText),
        onPressed: () => null,
        color: Colors.blue,
      ),
    );
  }
}
