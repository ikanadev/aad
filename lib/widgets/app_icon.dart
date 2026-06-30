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
      loader: AssetBytesLoader(icon.assetPath),
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}

enum AppIcons {
  bills,
  clothes,
  crypto,
  dance,
  dates,
  dinner,
  donations,
  drinks,
  entretainment,
  expensive,
  family,
  food,
  friends,
  gifts,
  groceries,
  grow,
  internet,
  job,
  junkFood,
  landRent,
  medical,
  negativeAdjustment,
  positiveAdjustment,
  rent,
  selfCare,
  taxi,
  travel;

  String get assetPath => 'assets/icons/vec/$name.vec';
}
