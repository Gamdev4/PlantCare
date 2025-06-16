import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:namer_app/constants/app_constants.dart';
import 'package:namer_app/l10n/app_localizations.dart';
import 'package:namer_app/pages/drawer/settings.dart';
import 'package:namer_app/pages/notifications_page.dart';
import 'package:namer_app/widgets/auto_watering.dart';
import 'package:namer_app/widgets/batery_level.dart';
import 'package:namer_app/widgets/humidity_level.dart';
import 'package:namer_app/widgets/watering_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isWatering = false;
  BluetoothConnection? _connection;
  bool _isConnecting = false;
  String _connectionStatus = 'Disconnected';
  int _humidityLevel = 0;
  List<BluetoothDevice> _devices = [];
  Timer? _wateringTimer;
  List<WateringSchedule> wateringSchedules = [];

  @override
  void initState() {
    super.initState();
    _initBluetooth();
    _startWateringChecker();
  }

  @override
  void dispose() {
    _wateringTimer?.cancel();
    _connection?.dispose();
    super.dispose();
  }

  void _startWateringChecker() {
    _wateringTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkWateringSchedules();
    });
  }

  void _checkWateringSchedules() {
    final now = DateTime.now();
    
    for (var schedule in wateringSchedules) {
      if (_shouldWaterNow(schedule, now)) {
        _startAutoWatering(schedule.duration);
        schedule.lastWatered = now;
      }
    }
  }

  bool _shouldWaterNow(WateringSchedule schedule, DateTime now) {
    final scheduledTime = DateTime(now.year, now.month, now.day, 
                                 schedule.time.hour, schedule.time.minute);
    final diffMinutes = now.difference(scheduledTime).inMinutes.abs();
    
    if (diffMinutes > 1) {
      return false;
    }
    
    if (schedule.lastWatered != null && 
        schedule.lastWatered!.year == now.year &&
        schedule.lastWatered!.month == now.month &&
        schedule.lastWatered!.day == now.day) {
      return false;
    }
    
    return _checkFrequency(schedule, now);
  }

  bool _checkFrequency(WateringSchedule schedule, DateTime now) {
    if (schedule.lastWatered == null) {
      return true;
    }
    
    final daysSinceLastWatering = now.difference(schedule.lastWatered!).inDays;
    
    switch (schedule.frequency) {
      case 'daily':
        return daysSinceLastWatering >= 1;
      case 'twoDays':
        return daysSinceLastWatering >= 2;
      case 'threeDays':
        return daysSinceLastWatering >= 3;
      case 'weekly':
        return daysSinceLastWatering >= 7;
      case 'monthly':
        return daysSinceLastWatering >= 30;
      default:
        return false;
    }
  }

  void _startAutoWatering(int durationSeconds) {
    if (_isWatering) return;
    
    setState(() => _isWatering = true);
    _sendCommand('1');
    
    Future.delayed(Duration(seconds: durationSeconds), () {
      if (mounted) {
        setState(() => _isWatering = false);
        _sendCommand('0');
      }
    });
  }

  Future<void> _initBluetooth() async {
    bool enabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
    if (!enabled) {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    _devices = await FlutterBluetoothSerial.instance.getBondedDevices();

    for (var device in _devices) {
      if (device.name?.contains("HC-05") == true || 
          device.name?.contains("Arduino") == true) {
        _connectToDevice(device);
        break;
      }
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      _updateStatus('Connecting...');
      setState(() => _isConnecting = true);

      _connection = await BluetoothConnection.toAddress(device.address);
      
      setState(() {
        _connectionStatus = 'Connected';
      });

      _connection!.input!.listen((Uint8List data) {
        String message = String.fromCharCodes(data).trim();
        _processBluetoothData(message);
      }).onDone(() {
        _updateStatus('Disconneted');
      });

    } catch (e) {
      _updateStatus('Connection error');
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  void _processBluetoothData(String message) {
    if (message.startsWith("P:")) {
      setState(() {
        _humidityLevel = int.tryParse(message.substring(2).replaceAll("%", "")) ?? 0;
      });
    } else if (message == "ON") {
      setState(() => _isWatering = true);
    } else if (message == "OFF") {
      setState(() => _isWatering = false);
    }
  }

  Future<void> _sendCommand(String command) async {
    if (_connection != null && _connection!.isConnected) {
      try {
        _connection!.output.add(Uint8List.fromList(command.codeUnits));
        await _connection!.output.allSent;
        debugPrint('Command sent: $command');
      } catch (e) {
        debugPrint('Error sending command: $e');
        _updateStatus('Error sending');
      }
    } else {
      debugPrint('No active Bluetooth connection');
      _updateStatus('Not connected');
    }
  }

  void _updateStatus(String status) {
    if (mounted) {
      setState(() => _connectionStatus = status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SettingsDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Text(
              _connectionStatus,
              style: TextStyle(
                fontSize: 12,
                color: _isConnecting 
                    ? Colors.amber 
                    : _connection != null 
                        ? Colors.green 
                        : Colors.red,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.settings, 
              color: Theme.of(context).colorScheme.onPrimary
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          PopupMenuButton<BluetoothDevice>(
            icon: Icon(
              Icons.bluetooth,
              color: _connection != null 
                  ? Colors.green[200] 
                  : Theme.of(context).colorScheme.onPrimary,
            ),
            itemBuilder: (context) {
              return _devices.map((device) {
                return PopupMenuItem(
                  value: device,
                  child: Text(device.name ?? "Disconnected Device"),
                );
              }).toList();
            },
            onSelected: (device) {
              _connectToDevice(device);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),

      // Background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        // Image
        child: Center(
          child: ListView(
            children: [
              Image.asset(
                AppConstants.plantImage,
                width: 400,
                height: 400,
              ),

              // Watering Button
              WateringButton(
                isActive: _isWatering,
                onPressed: () {
                  if (!_isWatering) {
                    setState(() => _isWatering = true);
                    _sendCommand('1');
                    
                    Future.delayed(const Duration(seconds: 5), () {
                      if (mounted) {
                        setState(() => _isWatering = false);
                        _sendCommand('0');
                      }
                    });
                  }
                },
              ),

              // Humedity and Batery Level
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: HumidityLevel(humidity: _humidityLevel),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BateryLevel(),
                    ),
                  ],
                ),
              ),

              // Auto Watering
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AutoWatering(
                  schedules: wateringSchedules,
                  onScheduleAdded: (schedule) {
                    setState(() {
                      wateringSchedules.add(schedule);
                    });
                  },
                  onScheduleRemoved: (index) {
                    setState(() {
                      wateringSchedules.removeAt(index);
                    });
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}