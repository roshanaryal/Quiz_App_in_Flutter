// ignore_for_file: prefer_const_constructors

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newsapp/answer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//audioplayer
//...
  AudioPlayer audioPlayer = AudioPlayer();
  // AudioCache audioCache;
  // String incorrectPath = "incorrect.mp3";
  // String correctPath = "correct.mp3";

  @override
  void initState() {
    super.initState();
    // audioCache = AudioCache( );
  }

//...
  List<Icon> _scoreTracker = [];
  int _questionIndex = 0;
  bool answerWasSelected = false;
  int _totalScore = 0;
  bool correctAnswerSelect = false;
  bool endOfQuiz = false;

  void _nextQuestion() {
    setState(() {
      answerWasSelected = false;
      if (_questionIndex == _questions.length - 1) {
        endOfQuiz = true;
      } else {
        _questionIndex++;
      }
    });
  }

  void restart() {
    setState(() {
      endOfQuiz = false;
      _scoreTracker = [];
      _questionIndex = 0;
      answerWasSelected = false;
      _totalScore = 0;
    });
  }

  void _checkAnswer(int i) {
    setState(() {
      if ((_questions[_questionIndex]['answers'])[0]['score']) {
        audioPlayer.play(AssetSource("correct.mp3"));
        // audioPlayer.set(AudioSource.uri(Uri.parse('asset:/your_file.mp3')),
        //     initialPosition: Duration.zero, preload: true);
        correctAnswerSelect = true;
        _scoreTracker.add(Icon(
          Icons.check_circle,
          color: Colors.blue,
        ));
      } else {
        audioPlayer.setSourceAsset("incorrect.mp3");
        // audioPlayer.play();
        // audioPlayer.play(AssetSource("incorrect.mp3"));
        correctAnswerSelect = false;
        _scoreTracker.add(Icon(
          Icons.clear,
          color: Colors.red,
        ));
      }
    });
  }

  void _answerTapFn(bool answerScore) {
    setState(() {
      answerWasSelected = true;

      if (answerScore) {
        correctAnswerSelect = true;

        _totalScore++;
        _scoreTracker.add(Icon(
          Icons.check_circle,
          color: Colors.blue,
        ));
      } else {
        correctAnswerSelect = false;

        _scoreTracker.add(Icon(
          Icons.clear,
          color: Colors.red,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Quiz app"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              if (_scoreTracker.isEmpty)
                SizedBox(
                  height: 25,
                ),
              if (_scoreTracker.length > 0) ..._scoreTracker
            ],
          ),
          Container(
            width: double.infinity,
            height: 130,
            margin: EdgeInsets.only(bottom: 10, left: 30, right: 30, top: 10),
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
                child: Text(
              _questions[_questionIndex]['question'],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
          ...(_questions[_questionIndex]['answers']
                  as List<Map<String, dynamic>>)
              .map(
            (answer) => Answer(
              answerText: answer['answerText'],
              answerColor: answerWasSelected
                  ? (answer['score'] ? Colors.green : Colors.red)
                  : Colors.white,
              answerTap: () {
                if (endOfQuiz) return;
                if (answerWasSelected) return;
                // Future.delayed(Duration.zero, () async {
                _answerTapFn(answer['score']);
                // });
              },
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: () {
              if (endOfQuiz) {
                restart();
                return;
              }
              if (!answerWasSelected) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Please select answer to procees nest question")));
                return;
              }
              ;

              _nextQuestion();
            },
            child: Text(endOfQuiz ? "Restart quiz" : "Next QUestion"),
            style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.0)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Text(
              "${_questionIndex + 1}/${_questions.length}",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ),
          if (answerWasSelected)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              height: 100,
              width: double.infinity,
              color: correctAnswerSelect ? Colors.green : Colors.red,
              child: Center(
                child: Text(
                  correctAnswerSelect ? "Correct answer" : "Incorrect answer",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          if (endOfQuiz)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text("Score $_totalScore /${_questions.length}"),
            )
        ],
      )),
    );
  }
}

// ignore: prefer_const_declarations
final List<Map<String, dynamic>> _questions = const [
  {
    'question': 'How long is New Zealand’s Ninety Mile Beach?',
    'answers': [
      {'answerText': '88km, so 55 miles long.', 'score': true},
      {'answerText': '55km, so 34 miles long.', 'score': false},
      {'answerText': '90km, so 56 miles long.', 'score': false},
    ],
  },
  {
    'question':
        'In which month does the German festival of Oktoberfest mostly take place?',
    'answers': [
      {'answerText': 'January', 'score': false},
      {'answerText': 'October', 'score': false},
      {'answerText': 'September', 'score': true},
    ],
  },
  {
    'question': 'Who composed the music for Sonic the Hedgehog 3?',
    'answers': [
      {'answerText': 'Britney Spears', 'score': false},
      {'answerText': 'Timbaland', 'score': false},
      {'answerText': 'Michael Jackson', 'score': true},
    ],
  },
  {
    'question': 'In Georgia (the state), it’s illegal to eat what with a fork?',
    'answers': [
      {'answerText': 'Hamburgers', 'score': false},
      {'answerText': 'Fried chicken', 'score': true},
      {'answerText': 'Pizza', 'score': false},
    ],
  },
  {
    'question':
        'Which part of his body did musician Gene Simmons from Kiss insure for one million dollars?',
    'answers': [
      {'answerText': 'His tongue', 'score': true},
      {'answerText': 'His leg', 'score': false},
      {'answerText': 'His butt', 'score': false},
    ],
  },
  {
    'question': 'In which country are Panama hats made?',
    'answers': [
      {'answerText': 'Ecuador', 'score': true},
      {'answerText': 'Panama (duh)', 'score': false},
      {'answerText': 'Portugal', 'score': false},
    ],
  },
  {
    'question': 'From which country do French fries originate?',
    'answers': [
      {'answerText': 'Belgium', 'score': true},
      {'answerText': 'France (duh)', 'score': false},
      {'answerText': 'Switzerland', 'score': false},
    ],
  },
  {
    'question': 'Which sea creature has three hearts?',
    'answers': [
      {'answerText': 'Great White Sharks', 'score': false},
      {'answerText': 'Killer Whales', 'score': false},
      {'answerText': 'The Octopus', 'score': true},
    ],
  },
  {
    'question': 'Which European country eats the most chocolate per capita?',
    'answers': [
      {'answerText': 'Belgium', 'score': false},
      {'answerText': 'The Netherlands', 'score': false},
      {'answerText': 'Switzerland', 'score': true},
    ],
  },
];
