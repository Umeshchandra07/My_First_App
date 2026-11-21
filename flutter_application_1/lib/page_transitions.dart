import 'package:material_ui/material_ui.dart';

Future<T?> navigateWithSlide<T extends Object?>(
  BuildContext context,
  Widget targetPage,
) {
  return Navigator.push<T>(
    context,
    PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => targetPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}
