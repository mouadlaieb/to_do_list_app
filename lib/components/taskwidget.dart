import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/edit_note_page.dart';
import 'package:todo_app/provider.dart';
import 'package:todo_app/task_model.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(10.0), // Add padding
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.yellow),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('hh:mm a').format(task.taskTime),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTaskScreen(task: task),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_note_rounded),
                color: Colors.blueAccent,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer<Model>(
                builder: (context, taskModel, child) {
                  return IconButton(
                    onPressed: () {
                      taskModel.toggleTaskCompletion(task);
                    },
                    icon: Icon(task.iscompleted
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded),
                    color: Colors.green,
                  );
                },
              ),
              Expanded(
                child: Consumer<Model>(
                  builder: (context, taskModel, child) {
                    return Text(
                      task.taskname ?? 'unnamed',
                      style: TextStyle(
                        decoration: task.iscompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              Consumer<Model>(
                builder: (context, taskmodel, child) {
                  return IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Deletion'),
                            content: const Text(
                                'Are you sure you want to delete this task?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  taskmodel.removeTask(task);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.delete_rounded),
                    color: Colors.red,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
