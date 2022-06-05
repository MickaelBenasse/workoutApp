import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout/models/profile.dart';
import 'package:workout/screens/workouts/workoutPage.dart';
import '../../constants/constant.dart';

class WorkoutOverview extends StatefulWidget {
  final dynamic workout;
  final dynamic videos;
  final dynamic exercises;
  final dynamic database;
  final List<History> historic;

  const WorkoutOverview({
    Key? key,
    required this.workout,
    required this.videos,
    required this.exercises,
    required this.historic,
    required this.database,
  }) : super(key: key);

  @override
  State<WorkoutOverview> createState() => _WorkoutOverviewState();
}

class _WorkoutOverviewState extends State<WorkoutOverview> {
  late final String firstExercise;
  late final String videoName;
  late String imageLink;

  String targetMuscles = "";
  List<dynamic> listTargetMuscle = [];

  int timeInSecond = 999999;
  String formattedTime = "";

  @override
  void initState() {

    firstExercise = widget.workout["sets"]["exercises"][0][0]["exerciseName"];
    videoName = firstExercise.contains("Run") || firstExercise.contains("Sprint")
        ? widget.exercises["run"]["videos"]
        : widget.exercises[firstExercise]["videos"];
    imageLink = widget.videos[videoName]["links"]["cam_a"];
    imageLink = imageLink.replaceAll(".mp4", ".jpg");

    for (var element in widget.historic) {
      if (element.workoutName.toLowerCase() == widget.workout["name"].toLowerCase() && element.time <= timeInSecond) {
        timeInSecond = element.time;
      }
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (timeInSecond != 999999) {
      final duration = Duration(seconds: timeInSecond);
      formattedTime =
          twoDigits(duration.inMinutes).toString() + " min " + twoDigits(duration.inSeconds.remainder(60)).toString() + " s";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    targetMuscles = "";
    listTargetMuscle = widget.workout["targetMuscles"];

    listTargetMuscle.forEach((muscle) {
      if (listTargetMuscle.first != muscle) {
        targetMuscles += " & " + muscle;
      } else {
        targetMuscles += muscle;
      }
    });

    return Container(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      height: 150,
      width: double.maxFinite,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: horizontalPadding * 2),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => WorkoutPage(
                      videos: widget.videos,
                      exercises: widget.exercises,
                      workout: widget.workout,
                      historic: widget.historic,
                      database: widget.database,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(defaultPadding, defaultPadding, 0, defaultPadding),
                decoration: BoxDecoration(
                  //color: blackGreyColor,
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      blackColor,
                      Color(0xff25272D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.workout["name"].toUpperCase(),
                      style: const TextStyle(
                        fontSize: headingSize,
                        fontFamily: "Antonio",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.workout["level"]),
                        Padding(
                          padding: const EdgeInsets.only(top: defaultPadding / 4),
                          child: Text(targetMuscles),
                        ),
                      ],
                    ),
                    _buildTime(),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(borderRadius),
                  image: DecorationImage(
                    image: AssetImage(imageLink),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    if (timeInSecond == 999999) {
      return Text(
        widget.workout["time"],
        style: const TextStyle(),
      );
    } else {
      return Text(
        formattedTime,
        style: const TextStyle(
          color: greyColor,
        ),
      );
    }
  }
}
