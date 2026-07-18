import 'package:aad/domain/models/app_state.dart';
import 'package:aad/domain/models/prefs_keys.dart';
import 'package:aad/domain/providers/app/shared_prefs_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AppStateNotifier extends _$AppStateNotifier {
  @override
  AppState build() {
    final prefs = ref.read(sharedPrefsProvider);
    return AppState(showAmounts: prefs.getBool(PrefsKeys.showAmounts) ?? false);
  }

  void toggleShowAmounts() {
    final next = state.copyWith(showAmounts: !state.showAmounts);
    state = next;
    ref
        .read(sharedPrefsProvider)
        .setBool(PrefsKeys.showAmounts, next.showAmounts)
        .ignore();
  }
}
