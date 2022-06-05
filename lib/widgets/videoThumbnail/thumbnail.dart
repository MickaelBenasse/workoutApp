import 'package:flutter/material.dart';

import '../../constants/constant.dart';

class Thumbnail extends StatelessWidget {
  final dynamic videos;
  final String imageLink;
  final bool isSelected;
  final Function onClick;
  final int index;

  const Thumbnail({
    Key? key,
    required this.videos,
    required this.imageLink,
    required this.isSelected,
    required this.onClick,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: defaultPadding),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? blackColor : greyColor,
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Image.asset(
          imageLink,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
