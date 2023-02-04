import 'package:workout_tracker/datetime/date_time.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  //reference hive box
  final _myBox = Hive.box('workout_database1');
  //check if there is already data stored,if not,record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("Previous data Not exists");
      _myBox.put('Start_Date', todaysDateDDMMYYYY());
      return false;
    } else {
      print('Previous data exists');
      return true;
    }
  }

  //return start date as ddmmyy
  String getStartDate() {
    return _myBox.get('Start_Date');
  }

  //write the data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout object into list of strings so that we can save in hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*
    check if any exercise has been done
    we will put a 0 or 1 for each ddmmyyyy date
    */

    if (exerciseCompleted(workouts)) {
      _myBox.put('COMPLETION_STATUS_${todaysDateDDMMYYYY()}', 1);
    } else {
      _myBox.put('COMPLETION_STATUS_${todaysDateDDMMYYYY()}', 0);
    }
    //save into hive
    _myBox.put('WORKOUTS', workoutList);
    _myBox.put('EXERCISE', exerciseList);
  }

  //read the data and return the list of data
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get('WORKOUTS');
    final exerciseDetails = _myBox.get('EXERCISES');

    //create workout objects
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have multiple exercises
      List<Exercise> exercisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //add each exercise to the list
        exercisesInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }
      //create the invidual workout
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);
      //add individual workout to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }

  //check if any exercise have been done
  bool exerciseCompleted(List<Workout> workouts) {
    //go through each workout
    for (var workout in workouts) {
      //go through each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion of given data
  int getCompletionStatus(String ddmmyyyy) {
    //return 0 or 1, if null then return 0
    int completionStatus = _myBox.get('COMPLETION_STATUS$ddmmyyyy') ?? 0;
    return completionStatus;
  }
}

//convert workout object into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //eg.[upperbody,lowerbody]
  ];
  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//convert the exercise in a workout object into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];
  //go through each workout
  for (int i = 0; i < workouts.length; i++) {
    //get exercise from each workout
    List<Exercise> exerciseInWorkout = workouts[i].exercises;

    List<List<String>> individualWorkout = [];
    //go through each exercise in exerciseList
    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exerciseInWorkout[j].name,
        exerciseInWorkout[j].weight,
        exerciseInWorkout[j].reps,
        exerciseInWorkout[j].sets,
        exerciseInWorkout[j].isCompleted.toString(),
      ]);
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
