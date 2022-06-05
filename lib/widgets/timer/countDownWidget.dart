import 'dart:async';
import 'package:flutter/material.dart';

import '../../constants/constant.dart';

class CountDownWidget extends StatefulWidget {
  final int duration;
  final Function? isFinished;

  const CountDownWidget({Key? key, required this.duration, this.isFinished}) : super(key: key);

  @override
  _CountDownWidgetState createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  late Duration countdownDuration;
  Duration duration = const Duration();
  Timer? timer;

  bool countDown = true;

  @override
  void initState() {
    super.initState();
    countdownDuration = Duration(seconds: widget.duration);
    reset();
    startTimer();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds <= 0) {
        timer?.cancel();
        widget.isFinished!(true);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Text(
      twoDigits(duration.inMinutes).toString() + " : " + twoDigits(duration.inSeconds.remainder(60)).toString(),
      style: const TextStyle(
        fontFamily: "Antonio",
        fontSize: 100,
        color: blackGreyColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
