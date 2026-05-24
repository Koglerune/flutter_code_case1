import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/database/local_database.dart';
import '../models/driver_model.dart';

final driverListProvider = NotifierProvider<DriverListNotifier, List<Driver>>(
  DriverListNotifier.new,
);

class DriverListNotifier extends Notifier<List<Driver>> {
  Box<Driver> get _box => LocalDatabase.driverBox;

  @override
  List<Driver> build() {
    return _box.values.toList();
  }

  void addDriver(String name) {
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newDriver = Driver(
      id: newId,
      name: name,
      lastUpdated: DateTime.now(),
    );

    _box.put(newId, newDriver);
    state = _box.values.toList();
  }

  void updateDriverStatus(String id, DriverStatus newStatus) {
    final driver = _box.get(id);
    if (driver != null) {
      driver.status = newStatus;
      driver.lastUpdated = DateTime.now();
      
      driver.save();
      state = _box.values.toList();
    }
  }

  void deleteDriver(String id) {
    _box.delete(id);
    state = _box.values.toList();
  }
}