import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout/constants/constant.dart';
import 'package:workout/models/profile.dart';
import 'package:workout/screens/workouts/InWorkoutPage.dart';
import 'package:workout/widgets/videoThumbnail/smallThumbnail.dart';
import '../../widgets/videoThumbnail/videoThumbnail.dart';

class WorkoutPage extends StatelessWidget {
  final dynamic workout;
  final dynamic videos;
  final dynamic exercises;
  final dynamic database;
  final List<History> historic;

  const WorkoutPage({
    Key? key,
    required this.videos,
    required this.exercises,
    required this.workout,
    required this.historic,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> exerciseList = [];

    workout["sets"]["exercises"].forEach((set) {
      set.forEach((exercise) {
        if (!exerciseList.contains(exercise["exerciseName"])) {
          if (exercise["exerciseName"].contains("Run") || exercise["exerciseName"].contains("Sprint")) {
            if (!exerciseList.contains("run")) {
              exerciseList.add("run");
            }
          } else if (!exercise["exerciseName"].contains("Rest")) {
            exerciseList.add(exercise["exerciseName"]);
          }
        }
      });
    });

    return Scaffold(
      appBar: PreferredSize(
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: blackColor,
              boxShadow: [
                BoxShadow(
                  color: blackColor,
                  blurRadius: 15.0,
                ), //BoxShadow
              ],
            ),
            alignment: Alignment.centerLeft,
            child: IconButton(
              splashRadius: 20,
              splashColor: whiteHoverColor,
              icon: const FaIcon(
                FontAwesomeIcons.arrowLeft,
                color: whiteColor,
                size: iconSize,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        preferredSize: const Size(double.maxFinite, 50),
      ),
      backgroundColor: blackColor,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              blackGradientColor,
              blueGradientColor,
            ],
          ),
        ),
        child: MaterialButton(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding * 1.5),
          elevation: 0,
          highlightElevation: 0,
          splashColor: whiteHoverColor,
          textColor: whiteColor,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          height: 50,
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => InWorkoutPage(
                  videos: videos,
                  exercises: exercises,
                  workout: workout,
                  historic: historic,
                  database: database,
                ),
              ),
            );
          },
          child: const Text(
            "Commencer",
            style: TextStyle(
              fontSize: titleSize,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: defaultPadding),
                          child: Text(
                            workout["name"].toUpperCase(),
                            style: const TextStyle(
                              fontFamily: "Antonio",
                              fontSize: bigSize,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: defaultPadding),
                          child: Text(
                            workout["description"],
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              height: 1.25,
                              color: greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: verticalPadding),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 225,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: exerciseList.map((exercise) {
                          bool isLast = exerciseList.last == exercise ? true : false;

                          return VideoThumbNail(
                            exercise: exercise,
                            videos: videos,
                            exercises: exercises,
                            isLast: isLast,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WorkoutInformation(
                          workout: workout,
                          historic: historic,
                        ),
                        WorkoutSets(workout: workout, videos: videos, exercises: exercises),
                        if (workout["picture"] != null)
                          const Padding(
                            padding: EdgeInsets.only(top: verticalPadding),
                            child: Text(
                              "Cibles",
                              style: TextStyle(
                                fontSize: headingSize,
                              ),
                            ),
                          ),
                        if (workout["picture"] != null) Image.asset(workout["picture"]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutInformation extends StatelessWidget {
  final dynamic workout;
  final List<History> historic;

  const WorkoutInformation({
    Key? key,
    required this.workout,
    required this.historic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int timeInSecond = 999999;
    String formattedTime = "";

    for (var element in historic) {
      if (element.workoutName.toLowerCase() == workout["name"].toLowerCase() && element.time <= timeInSecond) {
        timeInSecond = element.time;
      }
    }

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (timeInSecond != 999999) {
      final duration = Duration(seconds: timeInSecond);
      formattedTime =
          twoDigits(duration.inMinutes).toString() + " min " + twoDigits(duration.inSeconds.remainder(60)).toString() + " s";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: verticalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - (horizontalPadding * 2)) / 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 30,
                      child: const Icon(
                        FontAwesomeIcons.dumbbell,
                        color: greyColor,
                        size: iconSize / 1.25,
                      ),
                    ),
                    workout["equipment"].isEmpty
                        ? const Text(
                            "Aucun équipement",
                            style: TextStyle(
                              color: greyColor,
                            ),
                          )
                        : Row(
                            children: List<String>.from(workout["equipment"]).map((element) {
                              if (workout["equipment"].length == 1 || element == workout["equipment"].last) {
                                return Text(
                                  element,
                                  style: const TextStyle(
                                    color: greyColor,
                                  ),
                                );
                              } else {
                                return Text(
                                  element + ", ",
                                  style: const TextStyle(
                                    color: greyColor,
                                  ),
                                );
                              }
                            }).toList(),
                          ),
                  ],
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - (horizontalPadding * 2)) / 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 30,
                      child: const Icon(
                        FontAwesomeIcons.chartSimple,
                        color: greyColor,
                        size: iconSize,
                      ),
                    ),
                    const Text(
                      "Allure maximale",
                      style: TextStyle(
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - (horizontalPadding * 2)) / 2,
                child: timeInSecond == 999999
                    ? Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 30,
                            child: const Icon(
                              FontAwesomeIcons.stopwatch,
                              color: greyColor,
                              size: iconSize,
                            ),
                          ),
                          Text(
                            workout["time"],
                            style: const TextStyle(
                              color: greyColor,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 30,
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.p,
                                  color: greyColor,
                                  size: 10,
                                ),
                                Transform.translate(
                                  offset: const Offset(-2, 0),
                                  child: const Icon(
                                    FontAwesomeIcons.b,
                                    color: greyColor,
                                    size: 10,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            formattedTime,
                            style: const TextStyle(
                              color: greyColor,
                            ),
                          ),
                        ],
                      ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - (horizontalPadding * 2)) / 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: 30,
                      child: const Icon(
                        FontAwesomeIcons.award,
                        color: greyColor,
                        size: iconSize,
                      ),
                    ),
                    Text(
                      workout["points"].toString(),
                      style: const TextStyle(
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (workout["distance"] != null)
          Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: 30,
                child: const Icon(
                  FontAwesomeIcons.personRunning,
                  color: greyColor,
                  size: iconSize,
                ),
              ),
              Text(
                workout["distance"],
                style: const TextStyle(
                  color: greyColor,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class WorkoutSets extends StatelessWidget {
  final dynamic workout;
  final dynamic videos;
  final dynamic exercises;

  const WorkoutSets({
    Key? key,
    required this.workout,
    required this.videos,
    required this.exercises,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listExercisesOnlySet = workout["sets"]["exercises"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: verticalPadding * 1.5),
          child: Text(
            "Résumé",
            style: TextStyle(
              fontSize: headingSize,
            ),
          ),
        ),
        if (workout["sets"]["numberOfSet"] == workout["sets"]["exercises"].length)
          Column(
            children: List<dynamic>.from(workout["sets"]["exercises"]).map((set) {
              final index = workout["sets"]["exercises"].indexOf(set);
              final setString = "Série " + (index + 1).toString() + "/" + workout["sets"]["numberOfSet"].toString();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: Text(
                      setString,
                      style: const TextStyle(
                        color: greyColor,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List<dynamic>.from(workout["sets"]["exercises"][index]).map((exercise) {
                      return SmallThumbnail(videos: videos, exercise: exercise, exercises: exercises);
                    }).toList(),
                  )
                ],
              );
            }).toList(),
          ),
        if (workout["sets"]["numberOfSet"] != workout["sets"]["exercises"].length)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: Text(
                  workout["sets"]["numberOfSet"].toString() + " Séries",
                  style: const TextStyle(
                    color: greyColor,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<dynamic>.from(listExercisesOnlySet[0]).map((exercise) {
                  return SmallThumbnail(videos: videos, exercise: exercise, exercises: exercises);
                }).toList(),
              )
            ],
          ),
      ],
    );
  }
}
