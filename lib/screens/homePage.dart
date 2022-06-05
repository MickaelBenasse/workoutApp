import 'dart:convert';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout/models/profile.dart';
import 'package:workout/screens/workouts/workoutsPage.dart';
import 'package:workout/service/db.dart';
import '../constants/constant.dart';
import 'profilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;

  Map<String, dynamic> workouts = {};
  Map<String, dynamic> videos = {};
  Map<String, dynamic> exercises = {};
  Map<String, dynamic> profile = {};

  dynamic database;
  List<History> historic = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    var jsonText = await rootBundle.loadString('assets/data.json');
    Map<String, dynamic> map = jsonDecode(jsonText);

    workouts = map['workouts'];
    exercises = map['exercises'];
    videos = map['videos'];

    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'data.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          '''CREATE TABLE IF NOT EXISTS history (
              id INTEGER PRIMARY KEY, 
              workoutName TEXT, 
              date TEXT,
              time INTEGER,
              points INTEGER 
           );''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    historic = await Service().histories(database);

    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: blackColor,
        body: _selectedIndex == 0
            ? WorkoutsPage(
                workouts: workouts,
                videos: videos,
                exercises: exercises,
                isDataLoaded: isDataLoaded,
                database: database,
                historic: historic,
              )
            : ProfilePage(
                historic: historic,
              ),
        bottomNavigationBar: Container(
          margin:  const EdgeInsets.only(top: verticalPadding / 2),
          height: 50,
          child: GNav(
            tabBackgroundColor: blackGreyColor,
            color: whiteColor,
            activeColor: whiteColor,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            padding: const EdgeInsets.all(15),
            gap: defaultPadding,
            tabs: const [
              GButton(
                icon: FontAwesomeIcons.dumbbell,
                text: 'Workouts',
                iconSize: iconSize,
              ),
              GButton(
                icon: FontAwesomeIcons.user,
                text: 'Profile',
                iconSize: iconSize,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
