import 'package:flutter/material.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/globals.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView.separated(
        itemBuilder: (context,index) => ItemContainer(title: tasks[index]['title'],dateTime: "${tasks[index]['date']} - ${tasks[index]['time']}"),
        separatorBuilder: (context,index) => const SizedBox(height: 15,),
        itemCount: tasks.length,
      ),
    );
  }
}
