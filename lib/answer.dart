import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Answer extends StatelessWidget {
  final String? answerText;
  final Color answerColor;
  final Function answerTap;
  Answer({this.answerText, required this.answerColor, required this.answerTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        answerTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
        decoration: BoxDecoration(
            color: answerColor,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.blue)),
        child: Text(
          answerText.toString(),
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
