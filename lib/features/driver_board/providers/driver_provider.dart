import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/database/local_database.dart';
import '../models/driver_model.dart';

final driverListProvider = NotifierProvider<DriverListNotifier, List<Driver>>(
  DriverListNotifier.new,
);

class DriverListNotifier extends Notifier<List<Driver>> {
  Isar get _db => LocalDatabase.instance;

  @override
  List<Driver> build() {
    return _db.drivers.where().findAllSync();
  }

  void addDriver(String name) {
    final newDriver = Driver()
      ..name = name
      ..status = DriverStatus.idle
      ..lastUpdated = DateTime.now();

    _db.writeTxnSync(() {
      _db.drivers.putSync(newDriver);
    });
    
    state = _db.drivers.where().findAllSync();
  }

  void updateDriverStatus(int id, DriverStatus newStatus) {
    final driver = _db.drivers.getSync(id);
    if (driver != null) {
      driver.status = newStatus;
      driver.lastUpdated = DateTime.now();
      
      _db.writeTxnSync(() {
        _db.drivers.putSync(driver);
      });
      
      state = _db.drivers.where().findAllSync();
    }
  }

  void deleteDriver(int id) {
    _db.writeTxnSync(() {
      _db.drivers.deleteSync(id);
    });
    
    state = _db.drivers.where().findAllSync();
  }
}