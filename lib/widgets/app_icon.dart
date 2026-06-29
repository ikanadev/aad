import 'package:flutter/widgets.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.icon, this.size = 24, this.color});

  final AppIcons icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(icon.path),
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}

enum AppIcons {
  taxi('assets/icons/vec/taxi.vec');

  const AppIcons(this.path);

  final String path;
}
