import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskProvider with ChangeNotifier {
  late Box<Task> _tasksBox;

  TaskProvider() {
    _tasksBox = Hive.box<Task>('tasksBox');
  }

  List<Task> get tasks => _tasksBox.values.toList();

  void addTask(Task task) {
    _tasksBox.add(task);
    notifyListeners();
  }

  void updateTask(int index, Task task) {
    _tasksBox.putAt(index, task);
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasksBox.deleteAt(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    Task task = _tasksBox.getAt(index)!;
    task.isCompleted = !task.isCompleted;
    _tasksBox.putAt(index, task);
    notifyListeners();
  }
}
