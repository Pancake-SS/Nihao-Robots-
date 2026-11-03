import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

AppDatabase openAppDatabase() {
  return AppDatabase(
    driftDatabase(
      name: 'ni_hao_robot',
      native: DriftNativeOptions(
        databasePath: () async {
          final directory = await getApplicationSupportDirectory();
          await directory.create(recursive: true);
          return path.join(directory.path, 'ni_hao_robot.sqlite');
        },
      ),
    ),
  );
}
