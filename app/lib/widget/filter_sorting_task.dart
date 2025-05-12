// lib/widget/browse_task/task_filter_modal.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

Future<void> showTaskFilterModal({
  required BuildContext context,
  required List<String> selectedCategories,
  required double minBudget,
  required double maxBudget,
  required bool remoteOnly,
  required String selectedSort,
  required String selectedStatus,
  required Function({
    required List<String> categories,
    required double min,
    required double max,
    required bool remote,
    required String sort,
    required String status,
  })
  onApply,
}) async {
  List<String> tempCategories = [...selectedCategories];
  double tempMin = minBudget;
  double tempMax = maxBudget;
  bool tempRemote = remoteOnly;
  String tempSort = selectedSort;
  String tempStatus = selectedStatus;

  const List<String> allCategories = [
    "Cleaning",
    "Plumbing",
    "Electrical",
    "Handyman",
    "Moving",
    "Delivery",
    "Gardening",
    "Tutoring",
    "Tech Support",
    "Other",
  ];
  const List<String> statusOptions = [
    'All',
    'On Going',
    'In Progress',
    'Completed',
  ];
  const List<String> sortOptions = [
    'Recent',
    'Highest Budget',
    'Lowest Budget',
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter & Sort Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Categories'),
                  ),
                  Wrap(
                    spacing: 6,
                    children:
                        allCategories.map((category) {
                          final isSelected = tempCategories.contains(category);
                          return FilterChip(
                            // labelStyle: ,
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            labelStyle: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                            ),
                            label: Text(category),
                            selected: isSelected,
                            onSelected: (val) {
                              setModalState(() {
                                if (val) {
                                  tempCategories.add(category);
                                } else {
                                  tempCategories.remove(category);
                                }
                              });
                            },
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                       Text('remoteOnly'.tr()),
                      Switch(
                        value: tempRemote,
                        onChanged:
                            (val) => setModalState(() => tempRemote = val),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('${'minimumBudget'.tr()} \$${tempMin.toInt()}'),
                  ),
                  Slider(
                    value: tempMin,
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    label: '\$${tempMin.toInt()}',
                    onChanged: (value) {
                      setModalState(() {
                        tempMin = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: tempStatus,
                    items:
                        statusOptions
                            .map(
                              (status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setModalState(() => tempStatus = val!),
                    decoration:  InputDecoration(labelText: 'taskStatus'.tr()),
                  ),

                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: tempSort,
                    items:
                        sortOptions
                            .map(
                              (sort) => DropdownMenuItem(
                                value: sort,
                                child: Text(sort),
                              ),
                            )
                            .toList(),
                    onChanged: (val) => setModalState(() => tempSort = val!),
                    decoration: InputDecoration(labelText: 'sortBy'.tr()),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      onApply(
                        categories: tempCategories,
                        min: tempMin,
                        max: tempMax,
                        remote: tempRemote,
                        sort: tempSort,
                        status: tempStatus,
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(FluentIcons.filter_20_filled),
                    label: Text('applyFilters'.tr()),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
