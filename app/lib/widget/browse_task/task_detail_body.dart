import 'package:app/model/task.dart';
import 'package:app/model/user.dart';
import 'package:flutter/material.dart';

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

                //TODO: basic Infomation section

                //TODO:  IMAGES SECTION

                // TODO:  LOCATION DETAILS SECTION


                //TODO:  Poster detail SECTION

                // TODO: assigned provider section

                //TODO: COMMENT SECTION

                SizedBox(height: 100),
              ],
            ),
          
        ),
      ),
    );
  }
}
