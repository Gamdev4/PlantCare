import 'package:flutter/material.dart';
import 'package:namer_app/l10n/app_localizations.dart';

class WateringSchedule {
  final TimeOfDay time;
  final String frequency;
  final int duration;
  DateTime? lastWatered;

  WateringSchedule({
    required this.time,
    required this.frequency,
    required this.duration,
    this.lastWatered,
  });
}

class AutoWatering extends StatefulWidget {
  final List<WateringSchedule> schedules;
  final Function(WateringSchedule) onScheduleAdded;
  final Function(int) onScheduleRemoved;

  const AutoWatering({
    super.key,
    required this.schedules,
    required this.onScheduleAdded,
    required this.onScheduleRemoved,
  });

  @override
  _AutoWateringState createState() => _AutoWateringState();
}

class _AutoWateringState extends State<AutoWatering> {
  bool isConfiguring = false;
  TimeOfDay selectedTime = TimeOfDay.now();
  String frequency = 'daily';
  int duration = 30;

  final List<String> frequencyOptions = [
    'daily',
    'twoDays',
    'threeDays',
    'weekly',
    'monthly'
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _saveSchedule() {
    final newSchedule = WateringSchedule(
      time: selectedTime,
      frequency: frequency,
      duration: duration,
    );
    widget.onScheduleAdded(newSchedule);
    setState(() {
      isConfiguring = false;
      selectedTime = TimeOfDay.now();
      frequency = 'daily';
      duration = 30;
    });
  }

  String _getTranslatedFrequency(String key) {
    switch (key) {
      case 'daily':
        return AppLocalizations.of(context)!.daily;
      case 'twoDays':
        return AppLocalizations.of(context)!.twoDays;
      case 'threeDays':
        return AppLocalizations.of(context)!.threeDays;
      case 'weekly':
        return AppLocalizations.of(context)!.weekly;
      case 'monthly':
        return AppLocalizations.of(context)!.monthly;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 5.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isConfiguring ? _buildConfigurationView(context) : _buildSchedulesView(context),
        ),
      ),
    );
  }

  Widget _buildSchedulesView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.schedules.isNotEmpty)
          ...widget.schedules.asMap().entries.map((entry) {
            int index = entry.key;
            WateringSchedule schedule = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${schedule.time.format(context)} - ${_getTranslatedFrequency(schedule.frequency)} (${schedule.duration}${AppLocalizations.of(context)!.secondsAbbrev})",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onScheduleRemoved(index),
                  ),
                ],
              ),
            );
          }),
        InkWell(
          onTap: () {
            setState(() {
              isConfiguring = true;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 38,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.addSchedule,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfigurationView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.scheduleConfig,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey),
              onPressed: () {
                setState(() {
                  isConfiguring = false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.time,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                selectedTime.format(context),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.frequency,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            DropdownButton<String>(
              value: frequency,
              onChanged: (String? newValue) {
                setState(() {
                  frequency = newValue!;
                });
              },
              items: frequencyOptions
                  .map<DropdownMenuItem<String>>((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(_getTranslatedFrequency(key)),
                );
              }).toList(),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.duration,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            Expanded(
              child: Slider(
                value: duration.toDouble(),
                min: 1,
                max: 120,
                divisions: 119,
                label: '$duration ${AppLocalizations.of(context)!.secondsAbbrev}',
                onChanged: (double value) {
                  setState(() {
                    duration = value.round();
                  });
                },
              ),
            ),
          ],
        ),
        
        Center(
          child: Text(
            "$duration ${AppLocalizations.of(context)!.seconds}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        ElevatedButton(
          onPressed: _saveSchedule,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Text(AppLocalizations.of(context)!.saveSchedule),
        ),
      ],
    );
  }
}