import 'package:hive_flutter/hive_flutter.dart';
import '../../features/driver_board/models/driver_model.dart';

class LocalDatabase {
  static late Box<Driver> driverBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(DriverAdapter());
    Hive.registerAdapter(DriverStatusAdapter());

    driverBox = await Hive.openBox<Driver>('drivers');
  }
}