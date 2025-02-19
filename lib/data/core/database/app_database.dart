import 'package:audio_recorder_app/domain/types/json_type.dart';

abstract interface class AppDatabase {
  Future<List<JsonType>> readAll({
    String? orderByKey,
    bool orderByAsc = true,
  });

  Stream<List<JsonType>> watchAll({
    String? orderByKey,
    bool orderByAsc = true,
  });

  Future<void> upsert({
    required String id,
    required JsonType data,
  });

  Future<void> remove(String id);

  Future<void> clear();
}
