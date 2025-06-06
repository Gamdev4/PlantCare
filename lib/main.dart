import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantCare',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PlantWateringHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PlantWateringHomePage extends StatefulWidget {
  @override
  _PlantWateringHomePageState createState() => _PlantWateringHomePageState();
}

class _PlantWateringHomePageState extends State<PlantWateringHomePage> {
  double batteryLevel = 100;
  double humidityLevel = 100;
  double waterLevel = 100;
  bool isWatering = false;
  bool autoMode = false;
  Timer? _timer;
  
  // Configuración de programación
  TimeOfDay scheduleTime = TimeOfDay(hour: 8, minute: 0);
  double minHumidity = 40.0;
  String frequency = 'Diario';
  
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startSimulation() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Simulación de datos en tiempo real
        batteryLevel = max(0, batteryLevel - 0.1);
        
        if (!isWatering) {
          humidityLevel = max(0, humidityLevel - 0.2);
        } else {
          humidityLevel = min(100, humidityLevel + 2);
        }
        
        if (isWatering) {
          waterLevel = max(0, waterLevel - 0.5);
        }
        
        _updateNotifications();
      });
    });
  }

  void _updateNotifications() {
    notifications.clear();
    
    if (waterLevel < 15) {
      notifications.add(NotificationModel(
        id: 'water',
        type: NotificationType.error,
        message: '¡Falta de agua!',
        icon: Icons.water_drop,
      ));
    }
    
    if (humidityLevel < 25) {
      notifications.add(NotificationModel(
        id: 'humidity',
        type: NotificationType.warning,
        message: 'Humedad baja detectada',
        icon: Icons.opacity,
      ));
    }
    
    if (batteryLevel < 20) {
      notifications.add(NotificationModel(
        id: 'battery',
        type: NotificationType.warning,
        message: 'Batería baja',
        icon: Icons.battery_alert,
      ));
    }
  }

  void _handleManualWatering() {
    if (waterLevel > 5 && !isWatering) {
      setState(() {
        isWatering = true;
      });
      
      Timer(Duration(seconds: 3), () {
        setState(() {
          isWatering = false;
        });
      });
    }
  }

  Color _getBatteryColor() {
    if (batteryLevel > 50) return Colors.green;
    if (batteryLevel > 20) return Colors.orange;
    return Colors.red;
  }

  Color _getHumidityColor() {
    if (humidityLevel > 60) return Colors.green;
    if (humidityLevel > 30) return Colors.orange;
    return Colors.red;
  }

  Color _getWaterColor() {
    return waterLevel < 20 ? Colors.red : Colors.cyan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade50, Colors.cyan.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.cyan.shade400],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.eco, color: Colors.white, size: 32),
                          SizedBox(width: 8),
                          Text(
                            'PlantCare',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 28,
                          ),
                          if (notifications.isNotEmpty)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${notifications.length}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Notificaciones
                ...notifications.map((notif) => Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notif.type == NotificationType.error
                        ? Colors.red.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        notif.icon,
                        color: notif.type == NotificationType.error
                            ? Colors.red.shade800
                            : Colors.orange.shade800,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          notif.message,
                          style: TextStyle(
                            color: notif.type == NotificationType.error
                                ? Colors.red.shade800
                                : Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                
                // Tarjetas de estado
                _buildStatusCard(
                  'Batería',
                  '${batteryLevel.round()}%',
                  batteryLevel / 100,
                  _getBatteryColor(),
                  Icons.battery_full,
                ),
                
                SizedBox(height: 16),
                
                _buildStatusCard(
                  'Humedad del Suelo',
                  '${humidityLevel.round()}%',
                  humidityLevel / 100,
                  _getHumidityColor(),
                  Icons.water_drop,
                ),
                
                SizedBox(height: 16),
                
                _buildStatusCard(
                  'Nivel de Agua',
                  '${waterLevel.round()}%',
                  waterLevel / 100,
                  _getWaterColor(),
                  Icons.local_drink,
                ),
                
                SizedBox(height: 24),
                
                // Botón de riego manual
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: (isWatering || waterLevel < 5) ? null : _handleManualWatering,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isWatering 
                          ? Colors.blue.shade400 
                          : Colors.cyan.shade500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop, size: 24),
                        SizedBox(width: 8),
                        Text(
                          isWatering ? 'Regando...' : 'Regar Ahora',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Configuración de automatización
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade50, Colors.cyan.shade50],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.settings, color: Colors.green.shade600),
                              SizedBox(width: 8),
                              Text(
                                'Riego Automático',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: autoMode,
                            onChanged: (value) {
                              setState(() {
                                autoMode = value;
                              });
                            },
                            activeColor: Colors.green.shade500,
                          ),
                        ],
                      ),
                      
                      if (autoMode) ...[
                        SizedBox(height: 16),
                        _buildConfigRow(
                          'Hora de riego:',
                          scheduleTime.format(context),
                          () async {
                            final TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: scheduleTime,
                            );
                            if (picked != null) {
                              setState(() {
                                scheduleTime = picked;
                              });
                            }
                          },
                        ),
                        
                        SizedBox(height: 12),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Humedad mínima:',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Slider(
                                    value: minHumidity,
                                    min: 0,
                                    max: 100,
                                    divisions: 20,
                                    onChanged: (value) {
                                      setState(() {
                                        minHumidity = value;
                                      });
                                    },
                                    activeColor: Colors.green.shade500,
                                  ),
                                ),
                                Text(
                                  '${minHumidity.round()}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        SizedBox(height: 12),
                        
                        _buildConfigRow(
                          'Frecuencia:',
                          frequency,
                          () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                height: 200,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Diario'),
                                      onTap: () {
                                        setState(() => frequency = 'Diario');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Cada 2 días'),
                                      onTap: () {
                                        setState(() => frequency = 'Cada 2 días');
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: Text('Semanal'),
                                      onTap: () {
                                        setState(() => frequency = 'Semanal');
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Footer
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Estado: ${autoMode ? 'Modo Automático Activado' : 'Modo Manual'} • '
                    'Última actualización: ${TimeOfDay.now().format(context)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, double progress, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildConfigRow(String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: Colors.grey.shade500, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationModel {
  final String id;
  final NotificationType type;
  final String message;
  final IconData icon;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.icon,
  });
}

enum NotificationType {
  error,
  warning,
}