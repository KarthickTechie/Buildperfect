import 'package:flutter/material.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final List<IconData>? icons;
  final List<String>? label;
  final bool isExtend;
  final Function(int) onDestinationSelected;
  final Color? backgroundColor;
  final IconThemeData? selectedIconTheme;
  final Color? indicatorColor;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    this.icons,
    this.label,
    required this.isExtend,
    required this.onDestinationSelected,
    this.backgroundColor,
    this.selectedIconTheme,
    this.indicatorColor,
    });
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      elevation: 6,
      destinations:List.generate(label!.length, (index){
        return NavigationRailDestination(icon: Icon(icons![index]), label: Text(label![index]),padding: EdgeInsets.all(5));
      }),
      labelType: isExtend ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      selectedIndex: selectedIndex,
      extended: isExtend,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: backgroundColor,
      selectedIconTheme: selectedIconTheme,
      indicatorColor: indicatorColor,

  // 🟢 Custom shape for the selected indicator
  indicatorShape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(6),
    side: const BorderSide(color: Colors.white),
   
  )
    );
  }
}
