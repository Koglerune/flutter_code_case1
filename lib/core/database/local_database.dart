import 'package:hive_flutter/hive_flutter.dart';
import '../../features/driver_board/models/driver_model.dart';

class LocalDatabase {
  static late Box<Driver> driverBox;
  static late Box settingsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DriverAdapter());
    Hive.registerAdapter(DriverStatusAdapter());
    Hive.registerAdapter(HistoryEntryAdapter());

    driverBox = await Hive.openBox<Driver>('drivers');
    settingsBox = await Hive.openBox('settings');

    final dummyData = {
      'mert_kaya': {'name': 'Mert Kaya', 'hours': 6, 'distance': 312, 'earnings': 1840.0, 'truck': 'Scania R500'},
      'caner_yilmaz': {'name': 'Caner Yılmaz', 'hours': 4, 'distance': 150, 'earnings': 950.0, 'truck': 'Mercedes Actros'},
      'ayse_demir': {'name': 'Ayşe Demir', 'hours': 8, 'distance': 420, 'earnings': 2450.0, 'truck': 'Volvo FH16'},
      'burak_oz': {'name': 'Burak Öz', 'hours': 2, 'distance': 45, 'earnings': 300.0, 'truck': 'MAN TGX'},
      'deniz_ak': {'name': 'Deniz Ak', 'hours': 5, 'distance': 210, 'earnings': 1200.0, 'truck': 'Iveco Stralis'},
    };

    if (driverBox.isEmpty) {
      for (var entry in dummyData.entries) {
        final id = entry.key;
        final data = entry.value;
        driverBox.put(id, Driver(
          id: id, 
          name: data['name'] as String, 
          status: DriverStatus.idle, 
          lastUpdated: DateTime.now(),
          history: [HistoryEntry(statusText: 'Boşta', timestamp: DateTime.now())],
          hoursWorkedToday: data['hours'] as int,
          distanceTraveled: data['distance'] as int,
          earnings: data['earnings'] as double,
          truckName: data['truck'] as String,
        ));
      }
    } else {
      for (var driver in driverBox.values) {
        if (dummyData.containsKey(driver.id)) {
          final data = dummyData[driver.id]!;
          driver.hoursWorkedToday = data['hours'] as int;
          driver.distanceTraveled = data['distance'] as int;
          driver.earnings = data['earnings'] as double;
          driver.truckName = data['truck'] as String;
          driver.save();
        }
      }
    }
  }
}