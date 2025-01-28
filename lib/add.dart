import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_model.dart';
import 'task_provider.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Form key to manage the form state
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String priority = 'Low'; // Default priority
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Wrapping the input fields in a Form widget
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                // Using TextFormField for task title
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // Validation for the title field
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null; // Return null if the input is valid
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                // Using TextFormField for task description
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // Allow multiple lines for description
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Priority: ', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 16),
                  DropdownButton<String>(
                    value: priority,
                    items: [
                      DropdownMenuItem(
                        value: 'High',
                        child: Text(
                          'High',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Medium',
                        child: Text(
                          'Medium',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Low',
                        child: Text(
                          'Low',
                          style: TextStyle(color: Colors.yellow[700]),
                        ),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        priority = newValue!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dueDate != null
                          ? 'Due Date: ${DateFormat.yMMMd().format(dueDate!)}'
                          : 'No Due Date Selected',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          dueDate = selectedDate;
                        });
                      }
                    },
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Validate the form
                    Provider.of<TaskProvider>(context, listen: false).addTask(
                      Task(
                        title: titleController.text,
                        description: descriptionController.text,
                        dueDate: dueDate,
                        priority: priority,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Save Task',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
