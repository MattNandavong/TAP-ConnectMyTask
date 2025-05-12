import 'package:app/model/task.dart';
import 'package:app/model/user.dart';
import 'package:app/utils/auth_service.dart';
import 'package:app/widget/screen/chat_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class AssignedProviderSection extends StatelessWidget {
  
  final Task task;
  final String currentUserId;

  const AssignedProviderSection({
    required this.task,
    required this.currentUserId,
  });
  // User provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.assignedProvider != null) ...[
          FutureBuilder<User>(
            future: AuthService().getUserProfile(task.assignedProvider!.id),
            builder: (context, providerSnapshot) {
              if (providerSnapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              }
              if (!providerSnapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('failedToLoadProvider'.tr()),
                );
              }

              final provider = providerSnapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FluentIcons.person_arrow_right_20_filled,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'assignedTo'.tr(),
                            style: GoogleFonts.figtree(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    child: Row(
                      children: [
                        provider.buildAvatar(radius: 18),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.name,
                                style: GoogleFonts.figtree(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              Text(
                                provider.averageRating != null ||
                                        provider.averageRating! > 0
                                    ? '⭐ ${provider.averageRating!.toStringAsFixed(1)}'
                                    : 'noRatingYet'.tr(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        if(task.status.toLowerCase() != 'completed')
                        ElevatedButton.icon(
                          icon: Icon(FluentIcons.chat_20_filled),
                          label: Text("openChat".tr()),
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.blueAccent,
                            // foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          onPressed: () {
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ChatScreen(
                                      taskId: task.id,
                                      userId: currentUserId,
                                    ),
                              ),
                            );
                          
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}
