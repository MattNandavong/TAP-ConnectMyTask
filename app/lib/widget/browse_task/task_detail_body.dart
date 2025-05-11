import 'package:app/model/task.dart';
import 'package:app/model/user.dart';
import 'package:app/widget/task_detail/Image_section.dart';
import 'package:app/widget/task_detail/assigned_provider.dart';
import 'package:app/widget/task_detail/basic_info.dart';
import 'package:app/widget/task_detail/comment_section.dart';
import 'package:app/widget/task_detail/map_section.dart';
import 'package:app/widget/task_detail/posted_by.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailBody extends StatelessWidget {
  final Task task;
  final User user;
  final bool isPoster;
  final bool isCompleted;
  final String? currentUserId;
  final void Function()? onViewOffers;
  final void Function()? onOpenChat;
  final void Function()? onMarkComplete;
  final void Function()? onMakeOffer;
  final void Function()? showImageGallery;

  const TaskDetailBody({
    required this.task,
    required this.user,
    required this.isPoster,
    required this.isCompleted,
    this.currentUserId,
    this.onViewOffers,
    this.onOpenChat,
    this.onMarkComplete,
    this.onMakeOffer,
    this.showImageGallery,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMMd();


    return Positioned.fill(
      top: 80, // Leaves room for the status section
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                //BASIC INFORMATION
                BasicInfo(task: task, formatter: formatter),

                //IMAGES SECTION
                ImageSection(images: task.images),

                //LOCATION DETAILS 
                SizedBox(height: 20),
                LocationSection(location: task.location),
                SizedBox(height: 20),

                //PSTER DETAILS
                PostedByUser(user: user),
                SizedBox(height: 24),

                //ASSINGED PROVIDER DETAILS
                AssignedProviderSection(task: task, currentUserId: currentUserId!),
                SizedBox(height: 20),
                Text(
                  'comments'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),

                //COMMENT
                CommentSection(taskId: task.id),
                SizedBox(height: 20),

              //EXTRA SPACE
                SizedBox(height: 100),
              ],
            ),
          
        ),
      ),
    );
  }
}
