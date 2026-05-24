import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/local_database.dart';
import '../models/driver_model.dart';

final driverListProvider = NotifierProvider<DriverListNotifier, List<Driver>>(DriverListNotifier.new);
final activeDriverIdProvider = NotifierProvider<ActiveDriverNotifier, String>(ActiveDriverNotifier.new);

class DriverListNotifier extends Notifier<List<Driver>> {
  @override
  List<Driver> build() => LocalDatabase.driverBox.values.toList();

  void updateDriverStatus(String id, DriverStatus newStatus) {
    final driver = LocalDatabase.driverBox.get(id);
    if (driver != null) {
      driver.status = newStatus;
      driver.lastUpdated = DateTime.now();
      driver.tripStartTime = newStatus == DriverStatus.onRoute ? DateTime.now() : null;
      driver.save();
      state = LocalDatabase.driverBox.values.toList();
    }
  }
}

class ActiveDriverNotifier extends Notifier<String> {
  @override
  String build() => LocalDatabase.settingsBox.get('activeDriverId', defaultValue: 'mert_kaya');

  void setActiveDriver(String id) {
    state = id;
    LocalDatabase.settingsBox.put('activeDriverId', id);
  }
}