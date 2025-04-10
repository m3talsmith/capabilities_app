import 'package:capabilities_app/ui/screen_navigation_bar.dart';

class ScreenSecondaryNavigationBar extends ScreenNavigationBar {
  const ScreenSecondaryNavigationBar({
    super.key,
    super.title,
    super.actions,
    super.backgroundColor,
    super.titleColor,
    super.width,
  }) : super(showBackButton: false, showLogout: false);
}
