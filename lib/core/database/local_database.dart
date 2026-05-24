import 'package:hive_flutter/hive_flutter.dart';
import '../../features/driver_board/models/driver_model.dart';

class LocalDatabase {
  static late Box<Driver> driverBox;
  static late Box settingsBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DriverAdapter());
    Hive.registerAdapter(DriverStatusAdapter());

    driverBox = await Hive.openBox<Driver>('drivers');
    settingsBox = await Hive.openBox('settings');

    if (driverBox.isEmpty) {
      final names = ['Mert Kaya', 'Caner Yılmaz', 'Ayşe Demir', 'Burak Öz', 'Deniz Ak'];
      for (var name in names) {
        final id = name.toLowerCase().replaceAll(' ', '_');
        driverBox.put(id, Driver(id: id, name: name, status: DriverStatus.idle, lastUpdated: DateTime.now()));
      }
    }
  }
}