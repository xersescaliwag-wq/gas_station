import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'pages/home/home_page.dart';

class VoltexApp extends StatefulWidget {
  const VoltexApp({super.key});

  @override
  State<VoltexApp> createState() => _VoltexAppState();
}

class _VoltexAppState extends State<VoltexApp> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    Center(
      child: Text(
        'Station Logs',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: CupertinoColors.white),
      ),
    ),
    Center(
      child: Text(
        'Notifications',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: CupertinoColors.white),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: GlassScaffold(
        backgroundColor: CupertinoColors.transparent,
        bottomBar: GlassTabBar.bottom(
          settings: const LiquidGlassSettings(chromaticAberration: 1),
          tabs: const [
            GlassTab(icon: FaIcon(FontAwesomeIcons.house)),
            GlassTab(icon: FaIcon(FontAwesomeIcons.gasPump)),
            GlassTab(icon: FaIcon(FontAwesomeIcons.bell)),
          ],
          selectedIndex: selectedIndex,
          onTabSelected: (i) => setState(() => selectedIndex = i),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'asset/background.jpg',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Asset background.jpg not found in bundle.\nPlease perform a full rebuild.',
                    style: TextStyle(color: CupertinoColors.systemRed, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            pages[selectedIndex],
          ],
        ),
      ),
    );
  }
}
