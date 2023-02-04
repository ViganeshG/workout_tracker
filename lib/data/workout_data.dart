import 'package:flutter/material.dart';
import 'package:workout_tracker/datetime/date_time.dart';
import 'package:workout_tracker/models/exercise.dart';
import 'package:workout_tracker/models/workout.dart';
import 'hive_database.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

/* Workout Data structure

 -this is overall list contains the different workouts
 -Each workout has a name and list of exercises
 */

  List<Workout> workoutList = [
    //default Workout
    Workout(
      name: "Upper Body",
      exercises: [
        Exercise(
          name: "Biceps Curls",
          weight: "10",
          reps: "10",
          sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercises: [
        Exercise(
          name: "Hamstring Curls",
          weight: "10",
          reps: "10",
          sets: "3",
        ),
      ],
    ),
  ];

  //if there are workouts already in database, then get that workoutlist
  void initalizeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    // otherwise use default workouts
    else {
      db.saveToDatabase(workoutList);
    }
    loadHeatMap();
  }

  //get list of workout
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // add a workout to the list
  void addWorkout(String name) {
    //add a new workout with a blank list of exercise
    workoutList.add(Workout(
      name: name,
      exercises: [],
    ));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //add an exercise to a workout
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    // find the relevent workout

    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.add(Exercise(
      name: exerciseName,
      weight: weight,
      reps: reps,
      sets: sets,
    ));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check off the exercise

  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant exercise in that work out
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

  //get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWokout = getRelevantWorkout(workoutName);
    return relevantWokout.exercises.length;
  }

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name+ exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    //then find the relevant exercise in that workout

    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  //start date
  String getStartDate() {
    return db.getStartDate();
  }

  /*
  Heat Map

  */
  Map<DateTime, int> heatMapDataSet = {};
  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String ddmmyyyy =
          convertDateTimetoDDMMYYYY(startDate.add(Duration(days: 1)));

      int completionStatus = db.getCompletionStatus(ddmmyyyy);

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
