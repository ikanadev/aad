import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferencesWithCache sharedPrefs(Ref ref) => 
  throw UnimplementedError('should be initialized in main');
