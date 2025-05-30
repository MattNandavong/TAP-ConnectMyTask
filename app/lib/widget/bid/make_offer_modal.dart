import 'package:app/utils/task_service.dart';
import 'package:app/widget/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showMakeOfferModal(BuildContext context, String taskId) {
  final priceController = TextEditingController();
  final estimatedTimeNumberController = TextEditingController(); // Number part
  final commentController = TextEditingController();
  String estimatedTimeUnit = 'hour'; // Default unit

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Make an Offer',
                style: GoogleFonts.oswald(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price (AUD)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: estimatedTimeNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Estimated Time'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.all(5),

                    decoration: BoxDecoration(
                      // color: Colors.white,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: DropdownButton<String>(
                      // dropdownColor: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      value: estimatedTimeUnit,
                      onChanged: (value) {
                        if (value != null) {
                          estimatedTimeUnit = value;
                          (context as Element).markNeedsBuild();
                        }
                      },
                      items:
                          ['hour', 'day', 'month']
                              .map(
                                (unit) => DropdownMenuItem(
                                  value: unit,
                                  child: Text(
                                    unit[0].toUpperCase() + unit.substring(1),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: commentController,
                maxLines: 6,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: 'Comment (optional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () async {
                  final price = double.tryParse(priceController.text);
                  final estimatedNumber =
                      estimatedTimeNumberController.text.trim();
                  final comment = commentController.text.trim();

                  if (price != null && estimatedNumber.isNotEmpty) {
                    final estimatedTime =
                        "$estimatedNumber $estimatedTimeUnit";

                    try {
                      await TaskService().bidOnTask(
                        taskId,
                        price,
                        estimatedTime,
                        comment: comment.isNotEmpty ? comment : null,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Offer made successfully!')),
                      );
                    } catch (error) {
                      Navigator.pop(context);
                      if (error.toString().contains('Authorization failed')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Authorization failed. Please register as a provider.',
                            ),
                          ),
                        );
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Authorization failed'),
                              content: Text(
                                'Do you want to sign up as a provider?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AuthScreen(),
                                      ),
                                    );
                                  },
                                  child: Text('YES'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('No'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to make offer: $error'),
                          ),
                        );
                      }
                    }
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter valid offer details'),
                      ),
                    );
                  }
                },
                child: Text('Submit Offer'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      );
    },
  );
}
