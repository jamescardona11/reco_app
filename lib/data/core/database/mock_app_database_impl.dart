import 'package:audio_recorder_app/domain/types/json_type.dart';
import 'package:rxdart/rxdart.dart';

import 'app_database.dart';

class MockAppDatabaseImpl implements AppDatabase {
  MockAppDatabaseImpl();

  final BehaviorSubject<Map<String, JsonType>> _dbCollectionSubject = BehaviorSubject.seeded({});

  @override
  Future<List<JsonType>> readAll({
    String? orderByKey,
    bool orderByAsc = true,
  }) async {
    return _dbCollectionSubject.value.values.toList();
  }

  @override
  Stream<List<JsonType>> watchAll({
    String? orderByKey,
    bool orderByAsc = true,
  }) {
    return _dbCollectionSubject.stream.map((dbCollection) => dbCollection.values.toList());
  }

  @override
  Future<void> upsert({
    required String id,
    required JsonType data,
  }) async {
    final allItems = _dbCollectionSubject.value;
    allItems[id] = data;
    _dbCollectionSubject.add(allItems);
  }

  @override
  Future<void> remove(String id) async {
    final allItems = _dbCollectionSubject.value;
    allItems.remove(id);
    _dbCollectionSubject.add(allItems);
  }

  @override
  Future<void> clear() async {
    _dbCollectionSubject.add({});
  }
}
