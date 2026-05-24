import 'package:isar/isar.dart';

part 'driver_model.g.dart';

enum DriverStatus {
  idle,
  waitingForLoad,
  onRoute
}

@collection
class Driver {
  Id id = Isar.autoIncrement;

  late String name;

  @enumerated
  DriverStatus status = DriverStatus.idle;

  DateTime lastUpdated = DateTime.now();
}