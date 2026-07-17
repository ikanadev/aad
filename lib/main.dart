import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aad/router.dart';
import 'package:aad/utils/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
