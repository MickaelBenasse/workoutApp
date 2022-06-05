import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout/constants/constant.dart';
import 'package:workout/screens/workouts/exerciseVideoPage.dart';

class VideoThumbNail extends StatelessWidget {
  final dynamic exercises;
  final dynamic videos;
  final dynamic exercise;
  final bool isLast;

  const VideoThumbNail({
    Key? key,
    required this.videos,
    required this.exercise,
    required this.exercises,
    required this.isLast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageLink = "";
    if (exercise == "run") {
      imageLink = videos["run"]["links"]["cam_a"];
    } else {
      imageLink = videos[exercises[exercise]["videos"]]["links"]["cam_a"];
    }

    imageLink = imageLink.replaceAll(".mp4", ".jpg");


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ExerciseVideoPage(
                  videos: videos,
                  exercise: exercises[exercise]["videos"],
                ),
              ),
            );
          },
          child: Container(
            width: 200,
            height: 200,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(left: horizontalPadding, right: isLast ? horizontalPadding : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              image: DecorationImage(
                image: AssetImage(imageLink),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: 30,
              width: 30,
              margin: const EdgeInsets.only(right: defaultPadding, bottom: defaultPadding / 2),
              padding: const EdgeInsets.only(left: 2.5),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    blackGradientColor,
                    blueGradientColor,
                  ],
                ),
              ),
              child: const FaIcon(
                FontAwesomeIcons.play,
                color: whiteColor,
                size: iconSize / 1.5,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: horizontalPadding,
            right: isLast ? horizontalPadding : 0,
            top: defaultPadding / 2,
          ),
          child: Text(
            exercises[exercise]["name"],
            style: const TextStyle(
              fontSize: defaultSize,
            ),
          ),
        )
      ],
    );
  }
}
