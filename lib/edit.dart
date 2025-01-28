import 'package:flutter/material.dart';
import 'package:to_doapp/task_model.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final Task task;

  const EditScreen({Key? key, required this.task}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String priority;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    priority = widget.task.priority ?? 'Low'; // Default to 'Low' if null
    selectedDate = widget.task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? 'Due Date: ${DateFormat.yMMMd().format(selectedDate!)}'
                        : 'No Due Date',
                  ),
                  TextButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                        });
                      }
                    },
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTask = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      isCompleted: widget.task.isCompleted,
                      dueDate: selectedDate,
                      priority: priority,
                    );

                    Navigator.pop(
                        context, updatedTask); // Pass updated task back
                  }
                },
                child: Text(
                  'Save',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
