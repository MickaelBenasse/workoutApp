import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout/constants/constant.dart';
import 'package:workout/models/profile.dart';

class ProfilePage extends StatelessWidget {
  final List<History> historic;

  const ProfilePage({
    Key? key,
    required this.historic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalPoints = 0;
    for (var element in historic) {
      totalPoints += element.points;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: verticalPadding / 2),
            child: Text(
              "Profile",
              style: TextStyle(
                fontFamily: "Antonio",
                fontSize: bigSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: verticalPadding),
            child: Text(
              "Points totaux : " + totalPoints.toString(),
              style: const TextStyle(
                fontSize: defaultSize,
              ),
            ),
          ),
          if (historic.isEmpty)
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  "Aucun historique d'entrainement.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontFamily: "Antonio",
                  ),
                ),
              ),
            ),
          if (historic.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: historic.reversed.map((workout) {
                  final duration = Duration(seconds: workout.time);
                  String twoDigits(int n) => n.toString().padLeft(2, '0');

                  final formattedTime = twoDigits(duration.inMinutes).toString() +
                      " min " +
                      twoDigits(duration.inSeconds.remainder(60)).toString() +
                      " s";


                  return Container(
                    margin: const EdgeInsets.only(bottom: verticalPadding),
                    width: double.maxFinite,
                    height: 100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: horizontalPadding / 2, vertical: verticalPadding / 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          blackColor,
                          Color(0xff25272D),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              workout.workoutName,
                              style: const TextStyle(
                                fontSize: titleSize,
                                fontFamily: "Antonio",
                              ),
                            ),
                            Text(
                              workout.date,
                              style: const TextStyle(
                                fontSize: defaultSize - 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Temps effectué : " + formattedTime,
                              style: const TextStyle(
                                fontSize: defaultSize,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 25,
                                  child: const Icon(
                                    FontAwesomeIcons.award,
                                    color: greyColor,
                                    size: iconSize,
                                  ),
                                ),
                                Text(
                                  "+" + workout.points.toString(),
                                  style: const TextStyle(
                                    fontSize: defaultSize,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
