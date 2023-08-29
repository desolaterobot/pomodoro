//import 'dart:html';
import 'package:flutter/material.dart';
import 'main.dart';

Text spaceText(String text, {double spacing = 0, double scale = 1}) {
  return Text(
    text,
    textScaleFactor: scale,
    style: TextStyle(
      fontFamily: 'Space',
      letterSpacing: spacing,
    ),
  );
}

Text jetText(String text, {double spacing = 0, double scale = 1}) {
  return Text(
    text,
    textScaleFactor: scale,
    style: TextStyle(
      fontFamily: 'Jet',
      letterSpacing: spacing,
    ),
  );
}

AppBar barTitle(String title) {
  return AppBar(
    backgroundColor: barCol,
    title: spaceText(title, spacing: 3),
  );
}

ConstrainedBox textButton(
  String title, {
  required Color color,
  required Function() onPressed,
}) {
  return ConstrainedBox(
    constraints: BoxConstraints.tightFor(width: 150, height: 75),
    child: ElevatedButton(
      onPressed: onPressed,
      child: jetText(title, scale: 2),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
      ),
    ),
  );
}

String pomoText() {
  return """
The Pomodoro Technique is a popular time-management method that utilises alternate work sessions and short breaks in order to deter mental fatigue and encourage strengthened concentration.

The technique involves first working for 25 minutes, then taking a break for 5 minutes and recording what you have done. That counts as one pomodoro. After 4 pomodoros, take a 15-30 minutes long break. (This app defaults to 20 minutes.) Repeat this process throughout your work session.

Keep this timer app open as you work to deter you from other distractions from your phone. In this app, one 'pomodoro' constitutes the pair of 25 min of work followed by 5 or 20 min break. The color of the app will change whenever your 'pomodoro mode' changes. The color of the app is PINK when working, BLUE when taking a short break and PURPLE while taking a long break. 

Never feel unproductive again! :D
""";
}

IconData modeIcon(String mode) {
  if (mode == 'ready') {
    return Icons.flash_on;
  } else if (mode == 'work') {
    return Icons.computer;
  } else if (mode == 'shortBreak') {
    return Icons.airline_seat_recline_extra_rounded;
  } else if (mode == 'longBreak') {
    return Icons.videogame_asset_rounded;
  } else {
    return Icons.warning_amber_rounded;
  }
}
