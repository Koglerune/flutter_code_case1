import 'package:hive/hive.dart';

part 'driver_model.g.dart';

@HiveType(typeId: 0)
enum DriverStatus {
  @HiveField(0) idle,
  @HiveField(1) waitingForLoad,
  @HiveField(2) onRoute
}

@HiveType(typeId: 2)
class HistoryEntry extends HiveObject {
  @HiveField(0) late String statusText;
  @HiveField(1) late DateTime timestamp;

  HistoryEntry({required this.statusText, required this.timestamp});
}

@HiveType(typeId: 1)
class Driver extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String name;
  @HiveField(2) late DriverStatus status;
  @HiveField(3) late DateTime lastUpdated;
  @HiveField(4) DateTime? tripStartTime;
  @HiveField(5) List<HistoryEntry>? history;

  Driver({
    required this.id, 
    required this.name, 
    required this.status, 
    required this.lastUpdated, 
    this.tripStartTime,
    this.history,
  });
}