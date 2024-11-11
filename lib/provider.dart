import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/objectbox.dart';
import 'package:todo_app/task_model.dart';

class Model extends ChangeNotifier {
  ObjectBox? _objectBox;
  bool isLoading = true; // Loading flag

  List<Task> get tasks => _objectBox?.taskBox.getAll() ?? [];

  Model() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _objectBox = await ObjectBox.create();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Failed to initialize ObjectBox: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  // Get unique days from tasks
  List<String> get days {
    return tasks
        .map((task) => DateFormat('yyyy-MM-dd').format(task.taskTime))
        .toSet()
        .toList()
      ..sort();
  }

  // Get tasks for a specific day
  List<Task> getTasksForDay(String day) {
    DateTime date = DateTime.parse(day);
    return tasks
        .where((task) =>
            task.taskTime.year == date.year &&
            task.taskTime.month == date.month &&
            task.taskTime.day == date.day)
        .toList();
  }

  // Add a task to ObjectBox
  void addTask(Task task) {
    if (_objectBox != null) {
      _objectBox!.taskBox.put(task); // Save task to ObjectBox
      notifyListeners(); // Notify listeners after adding task
    }
  }

  // Remove a task from ObjectBox
  void removeTask(Task task) {
    if (_objectBox != null) {
      _objectBox!.taskBox.remove(task.id); // Remove task from ObjectBox
      notifyListeners();
    }
  }

  // Toggle task completion
  void toggleTaskCompletion(Task task) {
    if (_objectBox != null) {
      task.iscompleted = !task.iscompleted; // Toggle completion status
      _objectBox!.taskBox.put(task); // Update task in ObjectBox
      notifyListeners();
    }
  }

  // Update a task in ObjectBox
  void updateTask(Task task) {
    if (_objectBox != null) {
      _objectBox!.taskBox.put(task); // Update task in ObjectBox
      notifyListeners(); // Notify listeners after updating task
    }
  }
}
