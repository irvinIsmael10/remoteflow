import 'package:flutter/material.dart';
import 'applications_view.dart';
import 'favorites_view.dart';
import 'jobs_view.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.darkMode, required this.onThemeChanged});
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  final _pages = const [JobsView(), FavoritesView(), ApplicationsView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6558E8), Color(0xFF9C66F0)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.route_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Text('RemoteFlow', style: TextStyle(fontWeight: FontWeight.w900)),
        ]),
        actions: [
          IconButton(
            tooltip: widget.darkMode ? 'Modo claro' : 'Modo oscuro',
            onPressed: () => widget.onThemeChanged(!widget.darkMode),
            icon: Icon(widget.darkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.work_outline), selectedIcon: Icon(Icons.work), label: 'Vacantes'),
          NavigationDestination(icon: Icon(Icons.bookmark_border), selectedIcon: Icon(Icons.bookmark), label: 'Favoritos'),
          NavigationDestination(icon: Icon(Icons.track_changes_outlined), selectedIcon: Icon(Icons.track_changes), label: 'Postulaciones'),
        ],
      ),
    );
  }
}
