import 'package:cr/providers/major_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.theme,
    required this.provider,
  });

  final ThemeData theme;
  final MajorProvider provider;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: theme.colorScheme.inversePrimary,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.listCheck,
          ),
          label: "Tasks",
          tooltip: "Tasks",
        ),
        BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.message,
            ),
            label: "Messages",
            tooltip: "Messages"),
      ],
      selectedItemColor: theme.colorScheme.inverseSurface,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedIconTheme: IconThemeData(size: 18),
      unselectedItemColor: theme.colorScheme.secondary,
      currentIndex: provider.currentIndex,
      onTap: (value) {
        provider.updateIndex(value);
      },
    );
  }
}
