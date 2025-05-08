import 'package:app/model/task.dart';
import 'package:app/widget/browse_task/task_card_helpers.dart';
import 'package:flutter/material.dart';
import 'package:app/widget/browse_task/task_detail_screen.dart';


class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.context,
    required this.task,

  });

  final Task task;
  final context;


  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskDetailScreen(taskId: task.id),
        ),
      ),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskCardHelpers.getStatusText(task.status),
              TaskCardHelpers.getTaskDetail(context, task, false),
            ],
          ),
        ),
      ),
    );
  }
}
