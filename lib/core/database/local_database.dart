import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/driver_board/models/driver_model.dart';

class LocalDatabase {
  static late Isar instance;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    instance = await Isar.open(
      [DriverSchema],
      directory: dir.path,
    );
  }
}