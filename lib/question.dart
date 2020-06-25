import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child:Text(
      'Question: '+questionText,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28,),
      textAlign: TextAlign.center,),
    );
  }
}
