import 'package:aad/domain/models/prefs_keys.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/router.dart';
import 'package:aad/utils/app_theme.dart';
import 'package:aad/domain/providers/app/shared_prefs_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: SharedPreferencesWithCacheOptions(
      allowList: {PrefsKeys.showAmounts},
    ),
  );

  runApp(
    ProviderScope(
      overrides: [sharedPrefsProvider.overrideWithValue(prefs)],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark-only by design; the AppColor palette is validated for dark surfaces.
    // Wallpaper-derived scheme on Android 12+, seeded fallback elsewhere.
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp.router(
        title: 'AAD',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(
          darkDynamic ??
              ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.dark,
              ),
        ),
        routerConfig: router,
      ),
    );
  }
}
