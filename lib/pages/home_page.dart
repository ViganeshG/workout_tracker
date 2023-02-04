import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heat_map.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/models/workout.dart';
import 'package:workout_tracker/pages/workout_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
  }

  //text controller
  final newWorkoutNameController = TextEditingController();
  //create new workout
  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create new workout"),
        content: TextField(
          controller: newWorkoutNameController,
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
      ),
    );
  }

  //go to workout page
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
        ));
  }

//save workout
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController.text);
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
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Workout Tracker"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: createNewWorkout,
            child: const Icon(Icons.add),
          ),
          body: ListView(
            children: [
              //HeatMap
              MyHeatMap(
                  datasets: value.heatMapDataSet,
                  startDateDDMMYYYY: value.getStartDate()),
//Workout List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getWorkoutList().length,
                itemBuilder: ((context, index) => ListTile(
                      title: Text(value.getWorkoutList()[index].name),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () =>
                            goToWorkoutPage(value.getWorkoutList()[index].name),
                      ),
                    )),
              ),
            ],
          )),
    );
  }
}
