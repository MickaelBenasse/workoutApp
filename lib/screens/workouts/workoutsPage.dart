import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout/models/profile.dart';
import '../../constants/constant.dart';

import '../../widgets/workoutOverview/workoutOverview.dart';

class WorkoutsPage extends StatefulWidget {
  final Map<String, dynamic> workouts;
  final dynamic videos;
  final dynamic exercises;
  final dynamic database;
  final List<History> historic;
  final bool isDataLoaded;

  const WorkoutsPage({
    Key? key,
    required this.videos,
    required this.exercises,
    required this.workouts,
    required this.database,
    required this.historic,
    required this.isDataLoaded,
  }) : super(key: key);

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List equipmentButtons = [
    ["Barre de traction", false],
    ["Mur", false],
    ["Corde à sauter", false]
  ];

  List difficultyButtons = [
    ["Débutant", false],
    ["Intermédiaire", false],
    ["Avancé", false]
  ];

  List targetMuscleButtons = [
    ["Buste", false],
    ["Corps entier", false],
    ["Bas du corps", false],
    ["Haut", false]
  ];

  List<List> filter = [[], [], []];

  @override
  Widget build(BuildContext context) {
    var finalFilterList = Map.from(widget.workouts);

    if (widget.isDataLoaded) {
      if (filter[0].isNotEmpty || filter[1].isNotEmpty || filter[2].isNotEmpty) {
        for (var element in widget.workouts.values) {
          bool containsEquipment = false;
          for (var equipment in element["equipment"]) {
            if (filter[0].contains(equipment)) {
              containsEquipment = true;
            }
          }

          bool isDifficulty = false;
          if (filter[1].contains(element["level"])) {
            isDifficulty = true;
          }

          bool containsTargetMuscle = false;
          for (var targetMuscles in element["targetMuscles"]) {
            if (filter[2].contains(targetMuscles)) {
              containsTargetMuscle = true;
            }
          }

          if ((!containsEquipment && filter[0].isNotEmpty) ||
              (!isDifficulty && filter[1].isNotEmpty) ||
              (!containsTargetMuscle && filter[2].isNotEmpty)) {
            finalFilterList.remove(element["name"].toLowerCase());
          }
        }
      }

      return Scaffold(
        key: scaffoldKey,
        backgroundColor: blackColor,
        endDrawer: Drawer(
          child: _buildMyDrawer(),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 0),
          width: double.maxFinite,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Workouts de divinités",
                    style: TextStyle(
                      fontSize: titleSize,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    splashRadius: 20,
                    splashColor: whiteHoverColor,
                    icon: const FaIcon(
                      FontAwesomeIcons.sliders,
                      color: whiteColor,
                      size: iconSize,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState!.openEndDrawer(); //open drawer
                    },
                  ),
                ],
              ),
              if (finalFilterList.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.only(top: defaultPadding),
                      child: Column(
                        children: finalFilterList.values.map((workout) {
                          return WorkoutOverview(
                            workout: workout,
                            videos: widget.videos,
                            exercises: widget.exercises,
                            database: widget.database,
                            historic: widget.historic,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              if (finalFilterList.isEmpty)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Aucun résultats",
                      style: TextStyle(
                        fontSize: headingSize,
                        fontFamily: "Antonio",
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: double.maxFinite,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: blueColor,
          ),
        ),
      );
    }
  }

  Widget _buildMyDrawer() {
    return Container(
      margin: const EdgeInsets.only(left: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Filtre",
                style: TextStyle(
                  fontSize: titleSize,
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                splashRadius: 20,
                splashColor: whiteHoverColor,
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: blackColor,
                  size: iconSize,
                ),
                onPressed: () {
                  Navigator.pop(context); //open drawer
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Équipement :",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 500,
                  height: 45,
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: equipmentButtons.map((element) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            element[1] = !element[1];
                          });
                        },
                        child: Container(
                          width: 125,
                          height: 45,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: verticalPadding / 3, horizontal: horizontalPadding / 2),
                          margin: const EdgeInsets.only(right: horizontalPadding / 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor),
                            borderRadius: BorderRadius.circular(borderRadius / 2),
                            color: element[1] ? greyColor.withOpacity(0.75) : whiteColor,
                          ),
                          child: Text(
                            element[0],
                            style: const TextStyle(color: blackColor),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Difficulté :",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 500,
                  height: 45,
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: difficultyButtons.map((element) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            element[1] = !element[1];
                          });
                        },
                        child: Container(
                          width: 125,
                          height: 45,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: verticalPadding / 3, horizontal: horizontalPadding / 2),
                          margin: const EdgeInsets.only(right: horizontalPadding / 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor),
                            borderRadius: BorderRadius.circular(borderRadius / 2),
                            color: element[1] ? greyColor.withOpacity(0.75) : whiteColor,
                          ),
                          child: Text(
                            element[0],
                            style: const TextStyle(color: blackColor),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: verticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Groupe musculaire :",
                  style: TextStyle(
                    color: blackColor,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 500,
                  height: 45,
                  padding: const EdgeInsets.only(top: defaultPadding),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: targetMuscleButtons.map((element) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            element[1] = !element[1];
                          });
                        },
                        child: Container(
                          width: 125,
                          height: 45,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              vertical: verticalPadding / 3, horizontal: horizontalPadding / 2),
                          margin: const EdgeInsets.only(right: horizontalPadding / 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor),
                            borderRadius: BorderRadius.circular(borderRadius / 2),
                            color: element[1] ? greyColor.withOpacity(0.75) : whiteColor,
                          ),
                          child: Text(
                            element[0],
                            style: const TextStyle(color: blackColor),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.only(bottom: verticalPadding, right: horizontalPadding),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  filter = [[], [], []];
                  for (var element in equipmentButtons) {
                    element[1] = false;
                  }
                  for (var element in targetMuscleButtons) {
                    element[1] = false;
                  }
                  for (var element in difficultyButtons) {
                    element[1] = false;
                  }
                });
              },
              child: const Text(
                "Effacer les filtres",
                style: TextStyle(
                  fontSize: defaultSize,
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: defaultPadding, right: horizontalPadding),
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
              minWidth: double.maxFinite,
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
                filter = [[], [], []];
                for (var equipment in equipmentButtons) {
                  if (equipment[1]) {
                    filter[0].add(equipment[0]);
                  }
                }

                for (var difficulty in difficultyButtons) {
                  if (difficulty[1]) {
                    filter[1].add(difficulty[0]);
                  }
                }

                for (var targetMuscle in targetMuscleButtons) {
                  if (targetMuscle[1]) {
                    filter[2].add(targetMuscle[0]);
                  }
                }

                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: const Text(
                "Voir les résultats",
                style: TextStyle(
                  fontSize: titleSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
