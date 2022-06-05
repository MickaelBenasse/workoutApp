import 'package:flutter/material.dart';

import '../../constants/constant.dart';

class SmallThumbnail extends StatelessWidget {
  final dynamic videos;
  final dynamic exercise;
  final dynamic exercises;

  const SmallThumbnail({Key? key, required this.videos, required this.exercise, required this.exercises})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String thumbnailText = (exercise["repetition"] == 1 || exercise["repetition"] == null
            ? ""
            : exercise["repetition"].toString() + "x ") +
        (exercise["exerciseName"].contains("Rest") ||
                exercise["exerciseName"].contains("Sprint") ||
                exercise["exerciseName"].contains("Run")
            ? exercise["exerciseName"]
            : exercises[exercise["exerciseName"]]["name"]);

    return Padding(
      padding: const EdgeInsets.only(bottom: verticalPadding / 2),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width - (horizontalPadding * 2) - 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xff25272D),
                    blackColor,
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: !exercise["exerciseName"].contains("Rest")
                        ? exercise["exerciseName"].contains("Run") || exercise["exerciseName"].contains("Sprint")
                            ? AssetImage(
                                videos["run"]["links"]["cam_a"].replaceAll(".mp4", ".jpg"),
                              )
                            : AssetImage(
                                videos[exercises[exercise["exerciseName"]]["videos"]]["links"]["cam_a"]
                                    .replaceAll(".mp4", ".jpg"),
                              )
                        : AssetImage(
                            videos["rest"]["links"]["cam_b"],
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: horizontalPadding),
                child: Text(
                  thumbnailText,
                  style: const TextStyle(fontSize: defaultSize, color: greyColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
