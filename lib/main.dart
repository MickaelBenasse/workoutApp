import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout/screens/homePage.dart';
import 'constants/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: blackColor),
    );

    return MaterialApp(
      scrollBehavior: const ScrollBehavior(androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "AktivGrotesk",
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: whiteColor,
          displayColor: whiteColor,
        ),
        highlightColor: Colors.transparent,
      ),
      home: const HomePage(),
    );
  }
}
