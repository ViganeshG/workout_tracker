import '../models/exercise.dart';
import '../models/workout.dart';

class HiveDatabase {
  //reference hive box

  //check if there is already data stored,if not,record the start date

  //return start date as ddmmyy

  //write the data

  //read the data and return the list of data

  //check if any exercise have been done

  //return completion of given data
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
