import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app_bottom_nav_bar.dart';

void main() {
  testWidgets('tapping a nav item reports its index', (WidgetTester tester) async {
    int? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSideBottomNavBar(
            currentIndex: 0,
            items: const [
              SideNavItem(Icons.home_outlined, 'Home'),
              SideNavItem(Icons.person_outline, 'Profile'),
              SideNavItem(Icons.settings_outlined, 'Settings'),
            ],
            onTap: (index) => selected = index,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.person_outline));
    expect(selected, 1);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    expect(selected, 2);
  });

  testWidgets('selected item expands to reveal its label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSideBottomNavBar(
            currentIndex: 1,
            items: const [
              SideNavItem(Icons.home_outlined, 'Home'),
              SideNavItem(Icons.person_outline, 'Profile'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
  });
}