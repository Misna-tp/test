import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'task_model.dart';
import 'add.dart';
import 'edit.dart';
import 'task_provider.dart'; // Assuming this is implemented correctly

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register the TaskAdapter
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TaskAdapter());
  }

  // Open the tasksBox
  await Hive.openBox<Task>('tasksBox');

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: TaskListApp(),
    ),
  );
}

class TaskListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Task List', // Title in AppBar
              style: TextStyle(
                  color: Colors.blue, // Blue color
                  fontWeight: FontWeight.bold,
                  fontSize: 30 // Bold font
                  ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return TaskItemWidget(
            task: task,
            onEdit: () async {
              final updatedTask = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditScreen(task: task),
                ),
              );

              if (updatedTask != null) {
                taskProvider.updateTask(
                    index, updatedTask); // Update task in provider
              }
            },
            onDelete: () {
              taskProvider.deleteTask(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task deleted!')),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddScreen()),
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map priority to colors
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.green;
        break;
      case 'Low':
        priorityColor = Colors.yellow[700]!;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.2), // Subtle color background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: priorityColor, width: 2), // Priority border
      ),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            final index = Provider.of<TaskProvider>(context, listen: false)
                .tasks
                .indexOf(task);
            Provider.of<TaskProvider>(context, listen: false)
                .toggleTaskCompletion(index);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) // Display description if available
              Text(
                task.description,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            SizedBox(height: 4),
            Text(
              'Due: ${task.dueDate != null ? DateFormat.yMMMd().format(task.dueDate!) : 'No due date'}',
            ),
            SizedBox(height: 4),
            Text(
              'Priority: ${task.priority}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: priorityColor,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                          onDelete(); // Trigger the delete action
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
