import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  @Id()
  int id ;
  String taskname;
  String description;
  DateTime taskTime;
  bool iscompleted;

  Task({
   this.id=0,
    required this.taskname,
    required this.description,
    required this.taskTime,
    this.iscompleted = false,
  });
}