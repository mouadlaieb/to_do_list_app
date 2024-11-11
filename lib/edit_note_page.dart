import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider.dart';
import 'package:todo_app/task_model.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late Task editTask;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    editTask = Task(
      id: widget.task.id,
      taskname: widget.task.taskname,
      description: widget.task.description,
      taskTime: widget.task.taskTime,
    );

    _dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(editTask.taskTime),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
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
                controller: TextEditingController(text: editTask.taskname),
                onChanged: (value) {
                  setState(() {
                    editTask.taskname = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: editTask.description),
                onChanged: (value) {
                  setState(() {
                    editTask.description = value;
                  });
                },
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: editTask.taskTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(editTask.taskTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        editTask.taskTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        _dateController.text =
                            DateFormat('yyyy-MM-dd').format(editTask.taskTime);
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
                      'Select Date: ${DateFormat('yyyy-MM-dd').format(editTask.taskTime)}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: InkWell(
                  onTap: () {
                    if (editTask.taskname.isNotEmpty &&
                        editTask.description.isNotEmpty) {
                      Provider.of<Model>(context, listen: false)
                          .updateTask(editTask);
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
                      'Save Changes',
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
