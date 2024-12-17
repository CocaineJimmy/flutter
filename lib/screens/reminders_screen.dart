import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';

class RemindersScreen extends StatefulWidget {
  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final dbHelper = DatabaseHelper.instance;
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  List<Map<String, dynamic>> reminders = [];

  @override
  void initState() {
    super.initState();
    refreshReminders();
  }

  void refreshReminders() async {
    final data = await dbHelper.getData('reminders');
    setState(() {
      reminders = data;
    });
  }

  void addReminder() async {
    final description = descriptionController.text;
    final date = dateController.text;
    final time = timeController.text;

    if (description.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
      await dbHelper.insertData('reminders',
          {'description': description, 'date': date, 'time': time});
      refreshReminders();
      descriptionController.clear();
      dateController.clear();
      timeController.clear();
    }
  }

  void deleteReminder(int id) async {
    await dbHelper.deleteData('reminders', id);
    refreshReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Напоминания')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Описание'),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Дата (YYYY-MM-DD)'),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(labelText: 'Время (HH:MM)'),
                ),
                ElevatedButton(
                  child: Text('Добавить'),
                  onPressed: addReminder,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ListTile(
                  title: Text(reminder['description']),
                  subtitle: Text('${reminder['date']} ${reminder['time']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteReminder(reminder['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
