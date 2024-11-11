import 'package:todo_app/objectbox.g.dart';
import 'package:todo_app/task_model.dart';

class ObjectBox {
  late final Store store;
  late final Box<Task> taskBox;

  ObjectBox._create(this.store) {
    taskBox = Box<Task>(store);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  int addTask(Task task) => taskBox.put(task);

  List<Task> getAllTasks() => taskBox.getAll();

  void deleteTask(int id) => taskBox.remove(id);

  void toggleTaskCompletion(Task task) {
    task.iscompleted = !task.iscompleted;
    taskBox.put(task);
  }
}
