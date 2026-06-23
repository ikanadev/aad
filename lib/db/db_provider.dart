import 'package:aad/db/database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase db(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
