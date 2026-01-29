import 'package:connectivity_plus/connectivity_plus.dart';
import '../data/activity_repository.dart';
import 'ai_service.dart';

class SyncService {
  static void start() {
    Connectivity().onConnectivityChanged.listen((status) async {
      if (status != ConnectivityResult.none) {
        final unsynced = await ActivityRepository.getUnsynced();

        for (var item in unsynced) {
          try {
            await AIService.getFeedback(item['score']);
            await ActivityRepository.markSynced(item['id']);
          } catch (_) {
            // ignore and retry later
          }
        }
      }
    });
  }
}
