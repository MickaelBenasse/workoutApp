import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:workout/constants/constant.dart';
import 'package:workout/widgets/videoThumbnail/thumbnail.dart';

class ExerciseVideoPage extends StatefulWidget {
  final dynamic videos;
  final dynamic exercise;

  const ExerciseVideoPage({
    Key? key,
    required this.videos,
    required this.exercise,
  }) : super(key: key);

  @override
  State<ExerciseVideoPage> createState() => _ExerciseVideoPageState();
}

class _ExerciseVideoPageState extends State<ExerciseVideoPage> {
  final List<String> _linksList = [];
  late VideoPlayerController _controller;
  List<List> thumbnailList = [];
  int selectedVideo = 0;

  @override
  void initState() {
    super.initState();
    for (dynamic link in widget.videos[widget.exercise]["links"].values) {
      if (link == widget.videos[widget.exercise]["links"]["cam_a"]) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 3),
          color: whiteColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
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
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(right: defaultPadding, top: defaultPadding),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: blackColor.withOpacity(0.50),
                  ),
                  child: IconButton(
                    splashRadius: 20,
                    splashColor: whiteHoverColor,
                    icon: const FaIcon(
                      FontAwesomeIcons.xmark,
                      color: whiteColor,
                      size: iconSize + 2.5,
                    ),
                    onPressed: () async {
                      await _clearController();

                      Navigator.pop(context);
                    },
                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    _controller.dispose();
  }
}
