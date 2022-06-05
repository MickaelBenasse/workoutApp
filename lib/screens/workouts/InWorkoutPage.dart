import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:video_player/video_player.dart';
import 'package:workout/models/profile.dart';
import 'package:workout/screens/homePage.dart';
import 'package:workout/service/db.dart';

import '../../constants/constant.dart';
import '../../widgets/timer/countDownWidget.dart';
import '../../widgets/videoThumbnail/thumbnail.dart';

class InWorkoutPage extends StatefulWidget {
  final dynamic workout;
  final dynamic videos;
  final dynamic exercises;
  final dynamic database;
  final List<History> historic;

  const InWorkoutPage({
    Key? key,
    required this.videos,
    required this.exercises,
    required this.workout,
    required this.database,
    required this.historic,
  }) : super(key: key);

  @override
  State<InWorkoutPage> createState() => _InWorkoutPageState();
}

class _InWorkoutPageState extends State<InWorkoutPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final List<String> _linksList = [];
  late dynamic timeValue;
  late VideoPlayerController _controller;
  List<List> thumbnailList = [];
  List<List> completeWorkout = [];
  int selectedVideo = 0;
  int setIndex = 0;
  int exerciseIndex = 0;
  int nextSetIndex = 0;
  int nextExerciseIndex = 1;
  int previousSetIndex = 0;
  int previousExerciseIndex = 0;
  bool lastExercise = false;

  @override
  void initState() {
    super.initState();

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    //Creation of the list with the complete workout.
    if (widget.workout["sets"]["repetition"] == widget.workout["sets"]["exercises"].length) {
      for (dynamic set in widget.workout["sets"]["exercises"]) {
        List setList = [];
        for (dynamic exercise in set) {
          List<String> linksList = [];

          // Create a list with all the links of the videos
          for (dynamic links in widget.videos[widget.exercises[exercise["exerciseName"]]["videos"]]["links"].values) {
            linksList.add(links);
          }
          setList.add([widget.exercises[exercise["exerciseName"]]["name"], exercise["repetition"], linksList]);
        }
        completeWorkout.add(setList);
      }
    } else {
      dynamic set = widget.workout["sets"]["exercises"][0];
      List setList = [];

      for (dynamic exercise in set) {
        List<String> linksList = [];
        dynamic iteration;

        if (exercise["exerciseName"].contains("Sprint") || exercise["exerciseName"].contains("Run")) {
          iteration = widget.videos["run"]["links"].values;
        } else if (exercise["exerciseName"].contains("Rest")) {
          iteration = widget.videos["rest"]["links"].values;
        } else {
          iteration = widget.videos[widget.exercises[exercise["exerciseName"]]["videos"]]["links"].values;
        }

        // Create a list with all the links of the videos
        for (dynamic links in iteration) {
          linksList.add(links);
        }

        if (exercise["exerciseName"].contains("Sprint") || exercise["exerciseName"].contains("Run")) {
          setList.add([exercise["exerciseName"], exercise["repetition"], linksList]);
        } else if (exercise["exerciseName"].contains("Rest")) {
          setList.add([exercise["exerciseName"], exercise["restTime"], linksList]);
        } else {
          setList.add([widget.exercises[exercise["exerciseName"]]["name"], exercise["repetition"], linksList]);
        }
      }

      int counter = 1;
      while (counter <= widget.workout["sets"]["numberOfSet"]) {
        completeWorkout.add(setList);
        counter++;
      }
    }

    // Initialization of the first video
    for (dynamic link in completeWorkout[0][0][2]) {
      if (link == completeWorkout[0][0][2][0]) {
        thumbnailList.add([link.replaceAll(".mp4", ".jpg"), true]);
        _controller = VideoPlayerController.asset(link);
      } else {
        thumbnailList.add([link.replaceAll(".mp4", ".jpg"), false]);
      }
      _linksList.add(link);
    }

    _controller.addListener(() {});
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  void onClick(index) async {
    if (index != selectedVideo) {
      await _clearController();

      _controller = VideoPlayerController.asset(_linksList[index]);
      thumbnailList[selectedVideo][1] = false;
      selectedVideo = index;
      thumbnailList[selectedVideo][1] = true;
      _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.addListener(() {});
      _controller.play();
    }
  }

  Future<bool> _clearController() async {
    final oldController = _controller;
    await oldController.pause();
    await oldController.dispose();
    return true;
  }

  Future<void> onChange() async {
    selectedVideo = 0;

    if (exerciseIndex == completeWorkout[setIndex].length - 1) {
      setIndex++;
      exerciseIndex = 0;
    } else {
      exerciseIndex++;
    }

    // Check if this is the last exercise exist or not
    if (setIndex + 1 == completeWorkout.length && nextExerciseIndex + 1 == completeWorkout[setIndex].length) {
      lastExercise = true;
    } else {
      if (nextExerciseIndex == completeWorkout[nextSetIndex].length - 1) {
        nextSetIndex++;
        nextExerciseIndex = 0;
      } else {
        nextExerciseIndex++;
      }
    }

    thumbnailList.clear();
    _linksList.clear();

    for (dynamic link in completeWorkout[setIndex][exerciseIndex][2]) {
      if (link == completeWorkout[setIndex][exerciseIndex][2][0]) {
        thumbnailList.add([link.replaceAll(".mp4", ".jpg"), true]);
        _controller = VideoPlayerController.asset(link);
      } else {
        thumbnailList.add([link.replaceAll(".mp4", ".jpg"), false]);
      }

      _linksList.add(link);
    }

    _controller.addListener(() {});
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  Future<void> onReverseChange() async {
    selectedVideo = 0;
    if (!(exerciseIndex == 0 && setIndex == 0)) {
      await _clearController();

      lastExercise = false;

      nextExerciseIndex = exerciseIndex;
      nextSetIndex = setIndex;

      if (exerciseIndex == 0) {
        setIndex--;
        exerciseIndex = completeWorkout[setIndex].length - 1;
      } else {
        exerciseIndex--;
      }

      thumbnailList.clear();
      _linksList.clear();

      for (dynamic link in completeWorkout[setIndex][exerciseIndex][2]) {
        if (link == completeWorkout[setIndex][exerciseIndex][2][0]) {
          thumbnailList.add([link.replaceAll(".mp4", ".jpg"), true]);
          _controller = VideoPlayerController.asset(link);
        } else {
          thumbnailList.add([link.replaceAll(".mp4", ".jpg"), false]);
        }

        _linksList.add(link);
      }

      _controller.addListener(() {});
      _controller.setLooping(true);
      _controller.initialize().then((_) => setState(() {}));
      _controller.play();
    }


    // // Check if this is the last exercise exist or not
    // if (setIndex + 1 == completeWorkout.length && nextExerciseIndex + 1 == completeWorkout[setIndex].length) {
    //   lastExercise = true;
    // } else {
    //   if (nextExerciseIndex == ) {
    //     nextSetIndex--;
    //     nextExerciseIndex = completeWorkout[nextSetIndex].length - 1;
    //   } else {
    //     nextExerciseIndex--;
    //   }
    // }


  }

  bool checkName(String name) {
    return name.contains("Rest") || name.contains("Sprint") || name.contains("Run");
  }

  Future<void> saveToDatabase() async {
    await _controller.pause();

    int time = Duration(milliseconds: timeValue).inSeconds;

    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

    History thisWorkout = History(
      id: widget.historic.length,
      workoutName: widget.workout["name"],
      time: time,
      date: date,
      points: widget.workout["points"],
    );

    await Service().insertHistory(thisWorkout, widget.database);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) async {
            if (dragEndDetails.primaryVelocity! > 0) {
              onReverseChange();
            }
          },
          onTap: () async {
            if (setIndex == completeWorkout.length - 1 && exerciseIndex == completeWorkout[setIndex].length - 1) {
              _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
              _showMyDialog();
            } else {
              if (!(completeWorkout[setIndex][exerciseIndex][0].contains("Rest"))) {
                await _clearController();
                onChange();
              }
            }
          },
          child: Container(
            padding: completeWorkout[setIndex][exerciseIndex][0].contains("Rest")
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 3),
            color: whiteColor,
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (_controller.value.isInitialized)
                  Align(
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: 1.275,
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                if (!_controller.value.isInitialized)
                  Shimmer.fromColors(
                    baseColor: whiteColor,
                    highlightColor: greyColor.withOpacity(0.5),
                    child: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                    ),
                  ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: defaultPadding,
                      left: defaultPadding,
                    ),
                    child: Column(
                      children: thumbnailList.map((thumbnail) {
                        int index = thumbnailList.indexOf(thumbnail);
                        return Thumbnail(
                          videos: widget.videos,
                          imageLink: thumbnail[0],
                          isSelected: thumbnail[1],
                          onClick: onClick,
                          index: index,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (completeWorkout[setIndex][exerciseIndex][0].contains("Rest"))
                  Container(
                    color: whiteColor,
                    alignment: Alignment.center,
                    child: CountDownWidget(
                      duration: completeWorkout[setIndex][exerciseIndex][1],
                      isFinished: (bool bool) async {
                        if (bool) {
                          if (setIndex == completeWorkout.length - 1 &&
                              exerciseIndex == completeWorkout[setIndex].length - 1) {
                            _stopWatchTimer.onExecute.add(StopWatchExecute.stop);

                            _showMyDialog();
                          } else {
                            await _clearController();
                            onChange();
                          }
                        }
                      },
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!checkName(completeWorkout[setIndex][exerciseIndex][0]))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              completeWorkout[setIndex][exerciseIndex][1].toString(),
                              style: const TextStyle(
                                fontSize: bigSize,
                                color: blackColor,
                                fontFamily: "Antonio",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(
                                "x",
                                style: TextStyle(
                                  fontSize: headingSize,
                                  color: blackColor,
                                  fontFamily: "Antonio",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      Text(
                        completeWorkout[setIndex][exerciseIndex][0],
                        style: const TextStyle(
                          fontSize: headingSize,
                          color: blackColor,
                          fontFamily: "Antonio",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (!lastExercise)
                        Text(
                          "Suivant: " +
                              (checkName(completeWorkout[nextSetIndex][nextExerciseIndex][0])
                                  ? ""
                                  : completeWorkout[nextSetIndex][nextExerciseIndex][1].toString() + "x ") +
                              completeWorkout[nextSetIndex][nextExerciseIndex][0],
                          style: const TextStyle(
                            fontSize: titleSize,
                            color: greyTextColor,
                            fontFamily: "Antonio",
                          ),
                        ),
                      ProgressBar(
                        completeWorkout: completeWorkout,
                        currentIndex: [setIndex, exerciseIndex],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: StreamBuilder<int>(
                          stream: _stopWatchTimer.rawTime,
                          initialData: _stopWatchTimer.rawTime.value,
                          builder: (context, snapshot) {
                            timeValue = snapshot.data;
                            final displayTime = StopWatchTimer.getDisplayTime(
                              timeValue!,
                              hours: false,
                              milliSecond: false,
                            );

                            return Text(
                              displayTime,
                              style: const TextStyle(
                                fontFamily: "Antonio",
                                fontSize: bigSize,
                                color: blackGreyColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    final duration = Duration(seconds: timeValue);
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final formattedTime = twoDigits(duration.inMinutes).toString() +
        " min " +
        twoDigits(duration.inSeconds.remainder(60)).toString() +
        " s";

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blackGreyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          title: Text('Tu viens de finir le workout ' + widget.workout["name"].toLowerCase()),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tu viens de gagner ' + widget.workout["points"].toString() + " points."),
              Padding(
                padding: const EdgeInsets.only(top: defaultPadding / 2),
                child: Text("Tu as effectué un temps de " + formattedTime + "."),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Enregistrer ma perfomance',
                style: TextStyle(
                  color: whiteColor,
                ),
              ),
              onPressed: () async {
                await saveToDatabase();

                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                        (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _stopWatchTimer.dispose();
  }
}

class ProgressBar extends StatefulWidget {
  final List<List> completeWorkout;
  final List currentIndex;

  const ProgressBar({
    Key? key,
    required this.completeWorkout,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    List<int> indexes = [0, 0];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.completeWorkout.map((set) {
          double spacing = (horizontalPadding * 2) + (widget.completeWorkout.length * 5);
          double setSize = (MediaQuery
              .of(context)
              .size
              .width - spacing) / widget.completeWorkout.length;
          indexes[0]++;
          indexes[1] = 0;

          return Container(
            margin: indexes[0] == widget.completeWorkout.length ? EdgeInsets.zero : const EdgeInsets.only(right: 5),
            width: setSize,
            height: 5,
            child: Row(
              children: set.map((exercise) {
                double secondarySpacing = (set.length - 1) * 3;
                double exerciseSize = (setSize - secondarySpacing) / set.length;

                indexes[1]++;

                return Container(
                  width: exerciseSize,
                  margin: indexes[1] == set.length ? EdgeInsets.zero : const EdgeInsets.only(right: 3),
                  height: 5,
                  color: indexes[0] <= widget.currentIndex[0] ||
                      (indexes[1] <= widget.currentIndex[1] + 1 && indexes[0] <= (widget.currentIndex[0] + 1))
                      ? blueColor
                      : greyColor,
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
