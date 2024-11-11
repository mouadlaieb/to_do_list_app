import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider.dart';
import 'package:todo_app/task_model.dart';
import 'package:intl/intl.dart'; // Add this line for date formatting

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Task addTask = Task(taskname: '', description: '', taskTime: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  addTask.taskname = value;
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  addTask.description = value;
                },
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        addTask.taskTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      'Select Date: ${DateFormat('yyyy-MM-dd').format(addTask.taskTime)}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: InkWell(
                  onTap: () {
                    if (addTask.taskname.isNotEmpty &&
                        addTask.description.isNotEmpty) {
                      final newTask = Task(
                        taskname: addTask.taskname,
                        description: addTask.description,
                        taskTime: addTask.taskTime,
                      );
                      Provider.of<Model>(context, listen: false)
                          .addTask(newTask);
                      // Clear the fields after adding
                      setState(() {
                        addTask = Task(
                            taskname: '',
                            description: '',
                            taskTime: DateTime.now());
                      });
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      'Add Task',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
