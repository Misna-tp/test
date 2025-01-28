import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime? dueDate;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String priority;

  Task({
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
    this.priority = 'Low',
  });
}
