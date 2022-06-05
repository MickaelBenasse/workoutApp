class History {
  final int id;
  final String workoutName;
  final int time;
  final String date;
  final int points;

  const History({
    required this.id,
    required this.workoutName,
    required this.time,
    required this.date,
    required this.points,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutName': workoutName,
      'time': time,
      'date': date,
      'points': points,
    };
  }

  @override
  String toString() {
    return 'History{id: $id, workoutName: $workoutName, time: $time, date: $date,points: $points }';
  }
}
