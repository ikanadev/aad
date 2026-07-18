import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final bool showAmounts;

  const AppState({required this.showAmounts});

  AppState copyWith({bool? showAmounts}) {
    return AppState(showAmounts: showAmounts ?? this.showAmounts);
  }

  @override
  bool operator ==(Object other) {
    return other is AppState && showAmounts == other.showAmounts;
  }

  @override
  int get hashCode => showAmounts.hashCode;
}
