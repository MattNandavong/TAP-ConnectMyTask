import 'package:app/utils/location_input.dart';
import 'package:app/utils/task_service.dart';
import 'package:app/widget/screen/mytask_screen.dart';
import 'package:app/widget/screen/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:app/model/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _budgetController;
  late TextEditingController _categoryController;
  DateTime? _deadline;
  String? _deadlineType;
  final DateFormat _formatter = DateFormat.yMMMMd();
  TimeOfDay? _deadlineTime;
  bool _deadlineError = false;
  final _locationController = TextEditingController();
  String _locationType = 'remote'; // default
  String? _selectedAddress;
  double? _selectedLat;
  double? _selectedLng;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _budgetController = TextEditingController(
      text: widget.task.budget.toString(),
    );
    _categoryController = TextEditingController(text: widget.task.category);
    if (widget.task.deadline == null) {
      _deadlineType = 'Flexible';
      _deadline = null;
      _deadlineTime = null;
    } else {
      _deadlineType = 'I am not flexible';
      _deadline = widget.task.deadline;
      _deadlineTime = TimeOfDay.fromDateTime(widget.task.deadline!);
    }
    if (widget.task.location?.type == 'physical') {
      _locationType = 'physical';
      _selectedAddress = widget.task.location?.address;
      _selectedLat = widget.task.location?.lat;
      _selectedLng = widget.task.location?.lng;
      _locationController.text = _selectedAddress ?? '';
    } else {
      _locationType = 'remote';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _openLocationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              child: LocationInput(
                onPlaceSelected: (address, lat, lng) {
                  setState(() {
                    _selectedAddress = address;
                    _selectedLat = lat;
                    _selectedLng = lng;
                    _locationController.text = address;
                  });
                },
              ),
            ),
          ),
    );
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDate: _deadline ?? DateTime.now(),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _deadlineTime ?? TimeOfDay.now(),
      );
      setState(() {
        _deadline = date;
        _deadlineTime = time ?? TimeOfDay(hour: 23, minute: 59);
      });
    }
  }

  void _confirmEdit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate deadline if not flexible
    if (_deadlineType != 'Flexible' && _deadline == null) {
      setState(() => _deadlineError = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('pleaseSelectDeadline'.tr())));
      return;
    }

    setState(() => _deadlineError = false);

    try {
      final deadlineValue =
          _deadlineType == 'Flexible'
              ? null
              : DateTime(
                _deadline!.year,
                _deadline!.month,
                _deadline!.day,
                _deadlineTime?.hour ?? 23,
                _deadlineTime?.minute ?? 59,
              );

      await TaskService().updateTask(
        taskId: widget.task.id,
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        budget: double.tryParse(_budgetController.text.trim()),
        deadline: deadlineValue,
        category: _categoryController.text.trim(),
        location:
            _locationType == 'remote'
                ? {'type': 'remote'}
                : {
                  'type': 'physical',
                  'address': _selectedAddress ?? '',
                  'lat': _selectedLat ?? 0.0,
                  'lng': _selectedLng ?? 0.0,
                },
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('taskUpdatedSuccessfully'.tr())));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyTaskScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'failedToUpdateTask'.tr()} $e')),
      );
    }
  }

  void _deleteTask(String id) async {
    try {
      await TaskService().deleteTask(id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete Task Successul')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMMd();

    return Scaffold(
      appBar: AppBar(
        title: Text('editTask'.tr()),
        // backgroundColor: Colors.white,
        // surfaceTintColor: Colors.white,
        // elevation: 6,
        shadowColor: const Color.fromARGB(66, 190, 190, 190),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'title'.tr()),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'description'.tr()),
                maxLines: 3,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: '${'budget'.tr()} (AUD)',
                ),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'category'.tr()),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _deadlineType,
                dropdownColor: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10),
                decoration: InputDecoration(
                  labelText: 'deadline'.tr(),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                items:
                    ['I am not flexible', 'Flexible']
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _deadlineType = val;
                      if (_deadlineType == 'Flexible') {
                        _deadline = null;
                        _deadlineTime = null;
                      }
                    });
                  }
                },
              ),

              if (_deadlineType != 'Flexible')
                ListTile(
                  title: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            _deadlineError
                                ? Theme.of(context).colorScheme.error
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _deadline != null
                            ? '${_formatter.format(_deadline!)} ${_deadlineTime?.format(context) ?? ''}'
                            : 'selectDeadline'.tr(),
                        style: TextStyle(
                          color:
                              _deadlineError
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface,
                        ),
                      ),
                    ),
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: _pickDeadline,
                ),

              SizedBox(height: 12),

              SwitchListTile(
                title: Text('remoteTask'.tr()),
                value: _locationType == 'remote',
                onChanged: (val) {
                  setState(() {
                    _locationType = val ? 'remote' : 'physical';
                    if (val) {
                      _selectedAddress = null;
                      _selectedLat = null;
                      _selectedLng = null;
                      _locationController.clear();
                    }
                  });
                },
              ),

              if (_locationType == 'physical')
                GestureDetector(
                  onTap: _openLocationModal,
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        labelText: 'location'.tr(),
                        hintText: 'selectLocation'.tr(),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) {
                        if (_locationType == 'physical' &&
                            (val == null || val.isEmpty)) {
                          return 'pleaseSelectLocation'.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                ),

              SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _confirmEdit,
                icon: Icon(Icons.check),
                label: Text('confirmEdit'.tr(), style: TextStyle(fontSize: 18)),
                style: FilledButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _deleteTask(widget.task.id);
                },
                child: Text(
                  "Delete Task",
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
