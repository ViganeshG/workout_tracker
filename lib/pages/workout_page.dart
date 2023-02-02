import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/exercise_tile.dart';
import 'package:workout_tracker/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({
    super.key,
    required this.workoutName,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  //checkbox was checked
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

//textcontrollers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final setsController = TextEditingController();
  final repsController = TextEditingController();

  //create a new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a New Exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //exercise name
                  TextField(
                    controller: exerciseNameController,
                    decoration:
                        const InputDecoration(hintText: "Exercise Name"),
                  ),
                  //weight
                  TextField(
                    controller: weightController,
                    decoration: const InputDecoration(hintText: "weight"),
                  ),
                  //reps
                  TextField(
                    controller: repsController,
                    decoration: const InputDecoration(hintText: "reps"),
                  ),
                  //sets
                  TextField(
                    controller: setsController,
                    decoration: const InputDecoration(hintText: "sets"),
                  ),
                ],
              ),
              actions: [
                //save
                MaterialButton(
                  onPressed: save,
                  child: const Text("save"),
                ),

                //cancel
                MaterialButton(
                  onPressed: cancel,
                  child: const Text("cancel"),
                )
              ],
            ));
  }

  //save workout
  void save() {
    //get exercise name from textcontroller
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String sets = setsController.text;
    String reps = repsController.text;
    //add exercise to workout
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );
    //pop the dialog box
    Navigator.pop(context);
    clear();
  }

//cancel
  void cancel() {
    //pop the dialog box
    Navigator.pop(context);
    clear();
  }

  //clear Controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
        builder: (context, value, child) => Scaffold(
              appBar: AppBar(
                title: Text(widget.workoutName),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createNewExercise,
              ),
              body: ListView.builder(
                itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
                itemBuilder: (context, index) => ExerciseTile(
                    exerciseName: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .name,
                    weight: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .weight,
                    sets: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .sets,
                    reps: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .reps,
                    isCompleted: value
                        .getRelevantWorkout(widget.workoutName)
                        .exercises[index]
                        .isCompleted,
                    onCheckBoxChanged: (val) => onCheckBoxChanged(
                          widget.workoutName,
                          value
                              .getRelevantWorkout(widget.workoutName)
                              .exercises[index]
                              .name,
                        )),
              ),
            ));
  }
}
