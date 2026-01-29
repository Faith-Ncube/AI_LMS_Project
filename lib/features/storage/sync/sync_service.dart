import 'package:connectivity_plus/connectivity_plus.dart';
import '../local/progress_repository.dart';

class SyncService {
  final ProgressRepository _repository = ProgressRepository();

  Future<void> syncIfOnline() async {
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      return; // still offline
    }

    final unsynced = await _repository.getUnsyncedProgress();

    for (final item in unsynced) {
      // 🔥 SIMULATED CLOUD SYNC
      await Future.delayed(const Duration(milliseconds: 500));

      await _repository.markAsSynced(item['id']);
    }
  }
}
