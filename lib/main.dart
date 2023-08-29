import 'dart:async';
import 'package:flutter/material.dart';
import 'objects.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
//importing packages

//default colors
Color barCol = Colors.blueGrey;
Color bgCol = Colors.blueGrey.shade100;

//running the main material app
void main() => runApp(
  MaterialApp(
    home: HomePage(),
  ),
);

//stateful widget for homepage
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

//state for the homepage stateful widget
class _HomePageState extends State<HomePage> {
  //'constants'
  final Uri githubURL = Uri.parse('https://github.com/desolaterobot/pomo');
  final audioPlayer = AudioPlayer();
  int longBreakDuration = 20;
  int workDuration = 24;
  int shortBreakDuration = 4;
  // units
  int seconds = 59;
  int minutes = 0;
  int pomodoros = 0;
  int miniCycles = 1;
  int displayMinutes = 0;
  // defining times;
  int workTime = 25;
  int breakTime = 5;
  // defining modes
  List<String> modes = ["work", "shortBreak", "longBreak", "ready"];
  String currentMode = "ready";
  // misc
  String buttonText = "START";
  late Timer timer;
  bool timerStarted = false;
  String mode = "READY?";
  IconData iconMode = Icons.flash_on;

  //the functions
  void startTimer() {
    buttonText = "RESET";
    seconds = -1;
    if (!timerStarted) {
      timerStarted = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        //*FUNCTION CALLS EVERY SECOND
        setState(() {
          iconMode = modeIcon(currentMode);
          if ((59 - seconds) == 0 && displayMinutes == 0) {
            audioPlayer.play(AssetSource("bell.mp3"));
          }
          // code to set units periodically
          seconds++;
          if (seconds > 59) {
            minutes++;
            seconds = 0;
          }
          if (miniCycles == 4) {
            breakTime = longBreakDuration;
          } else {
            breakTime = shortBreakDuration;
          }
          // which mode are we in?
          if (minutes < workTime) {
            // working.
            currentMode = modes[0];
          } else if (minutes <= (workTime + breakTime)) {
            // taking break, but which one?
            if (miniCycles != 4) {
              // short break
              currentMode = modes[1];
            } else {
              // long break
              currentMode = modes[2];
            }
          } else if (minutes >= (workTime + breakTime)) {
            pomodoros++;
            minutes = 0;
            if (miniCycles >= 4) {
              miniCycles = 1;
            } else {
              miniCycles++;
            }
          }
          switch (currentMode) {
            case "work":
              {
                displayMinutes = (workTime - minutes - 1);
                barCol = Colors.pink;
                bgCol = Colors.pink.shade100;
                mode = "WORKING";
              }
              break;
            case "shortBreak":
              {
                displayMinutes = breakTime - (minutes - workTime);
                barCol = Colors.blue;
                bgCol = Colors.blue.shade100;
                mode = "BREAK";
              }
              break;
            case "longBreak":
              {
                displayMinutes = breakTime - (minutes - workTime);
                barCol = Colors.purple;
                bgCol = Colors.purple.shade100;
                mode = "LONG BREAK";
              }
              break;
          }
        });
      });
    } else {
      setState(() {
        iconMode = Icons.flash_on;
        mode = "READY?";
        barCol = Colors.blueGrey;
        bgCol = Colors.blueGrey.shade100;
        timerStarted = false;
        seconds = 59;
        minutes = 0;
        pomodoros = 0;
        displayMinutes = 0;
        miniCycles = 1;
        breakTime = shortBreakDuration;
        currentMode = "ready";
        timer.cancel();
        buttonText = "START";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //?TOP APP BAR
      appBar: barTitle("Pomodoro Timer"),
      backgroundColor: bgCol,

      //?BODY
      body: Center(
        child: Column(
          children: [
            //TIME VIEW
            SizedBox(height: 100),
            Icon(iconMode),
            SizedBox(height: 10),
            jetText(mode, scale: 2), //!CHANGE
            SizedBox(height: 50),
            jetText(
                "${displayMinutes.toString().padLeft(2, '0')}:${(59 - seconds).toString().padLeft(2, '0')}",
                scale: 7), //!CHANGE
            SizedBox(height: 50),
            //BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textButton(
                  buttonText,
                  color: barCol,
                  onPressed: startTimer,
                ),
              ],
            ),
            SizedBox(height: 50),
            jetText(
              "${pomodoros} POMODOROS",
              scale: 2,
            ),
          ],
        ),
      ),

      //?FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        tooltip: "Info",
        backgroundColor: barCol,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: spaceText("The Pomodoro Technique"),
              content: SingleChildScrollView(
                child: spaceText(pomoText()),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (!await launchUrl(githubURL)) {
                        throw Exception('Could not load URL');
                      }
                    },
                    child: spaceText("GITHUB PAGE", scale: 1.6)),
                SizedBox(width: 20),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: spaceText("CLOSE", scale: 1.6)),
              ],
            ),
          );
        },
        child: Icon(
          Icons.info,
        ),
      ),
    );
  }
}
