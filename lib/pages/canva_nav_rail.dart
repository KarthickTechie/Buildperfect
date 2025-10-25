import 'package:flutter/material.dart';

class CanvaRail extends StatelessWidget {
  const CanvaRail({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Canva Navigation Rail',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: CanvaNavigationRailExample(),
    );
  }
}

class CanvaNavigationRailExample extends StatefulWidget {
  const CanvaNavigationRailExample({super.key});

  @override
  _CanvaNavigationRailExampleState createState() =>
      _CanvaNavigationRailExampleState();
}

class _CanvaNavigationRailExampleState
    extends State<CanvaNavigationRailExample> {
  int _selectedIndex = 0;

  final List<NavigationRailDestination> _destinations = [
    NavigationRailDestination(
      icon: Icon(Icons.folder_outlined, color: Colors.white, size: 24),
      selectedIcon: Icon(Icons.folder, color: Color(0xFF00C4B4), size: 24),
      label: Text(
        'Templates',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 24),
      selectedIcon: Icon(
        Icons.cloud_upload,
        color: Color(0xFF00C4B4),
        size: 24,
      ),
      label: Text(
        'Uploads',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.photo_library_outlined, color: Colors.white, size: 24),
      selectedIcon: Icon(
        Icons.photo_library,
        color: Color(0xFF00C4B4),
        size: 24,
      ),
      label: Text(
        'Photos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.star_border_outlined, color: Colors.white, size: 24),
      selectedIcon: Icon(Icons.star, color: Color(0xFF00C4B4), size: 24),
      label: Text(
        'Elements',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.format_align_center, color: Colors.white, size: 24),
      selectedIcon: Icon(
        Icons.format_textdirection_l_to_r,
        color: Color(0xFF00C4B4),
        size: 24,
      ),
      label: Text(
        'Text',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.music_note_outlined, color: Colors.white, size: 24),
      selectedIcon: Icon(Icons.music_note, color: Color(0xFF00C4B4), size: 24),
      label: Text(
        'Music',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(
        Icons.play_circle_outline_outlined,
        color: Colors.white,
        size: 24,
      ),
      selectedIcon: Icon(
        Icons.play_circle_outline,
        color: Color(0xFF00C4B4),
        size: 24,
      ),
      label: Text(
        'Videos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.grid_view_outlined, color: Colors.white, size: 24),
      selectedIcon: Icon(Icons.grid_view, color: Color(0xFF00C4B4), size: 24),
      label: Text(
        'Backgrounds',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 72,
            color: Color(0xFF1A1A1A), // Dark background matching Canva sidebar
            child: NavigationRail(
              backgroundColor: Colors.transparent,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xFF00C4B4),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
              destinations: _destinations,
              trailing: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
