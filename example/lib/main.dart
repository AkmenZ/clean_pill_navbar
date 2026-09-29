import 'package:clean_pill_navbar/clean_pill_navbar.dart';
import 'package:material_ui/material_ui.dart';

const _loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do '
    'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
    'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut '
    'aliquip ex ea commodo consequat. Duis aute irure dolor in '
    'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
    'pariatur.';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: '.SF Pro Text',
        scaffoldBackgroundColor: const Color(0xFFF7F7F9),
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int selectedIndex = 0;

  final items = const [
    PillNavBarItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    PillNavBarItem(icon: Icons.search, label: 'Search'),
    PillNavBarItem(
      icon: Icons.favorite_border,
      selectedIcon: Icons.favorite,
      label: 'Likes',
    ),
    PillNavBarItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  static const _pageColors = [
    Color(0xFFEAF2FF),
    Color(0xFFFFF3E0),
    Color(0xFFFCE4EC),
    Color(0xFFE8F5E9),
  ];

  static const _pageTitles = ['Home', 'Search', 'Likes', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageColors[selectedIndex],
      body: Stack(
        children: [
          // Content fills the whole screen, including behind the navbar.
          SafeArea(
            bottom: false,
            child: _CardListPage(
              key: ValueKey(selectedIndex),
              title: _pageTitles[selectedIndex],
            ),
          ),
          // Floating navbar on top, with horizontal margin from the edges.
          Positioned(
            left: 20,
            right: 20,
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PillNavBar(
                    items: items,
                    selectedIndex: selectedIndex,
                    onTap: (i) => setState(() => selectedIndex = i),
                    showSelectedLabelOnly: true,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.0,
                    ),
                    outerPadding: 4.0,
                    backgroundColor: Colors.white.withValues(alpha: 0.20),
                    enableBackgroundBlur: true,
                    blurSigma: 6.0,
                    borderColor: Colors.grey,
                    indicatorColor: Colors.blueAccent,
                    indicatorBorderColor: Colors.transparent,
                    selectedColor: Colors.white,
                    unselectedColor: const Color(0xFF8E8E93),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardListPage extends StatelessWidget {
  const _CardListPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Extra bottom padding so the last cards aren't hidden under the navbar.
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(10, (index) => _LoremCard(index: index)),
        ],
      ),
    );
  }
}

class _LoremCard extends StatelessWidget {
  const _LoremCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E5EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card ${index + 1}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            _loremIpsum,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF6E6E73),
            ),
          ),
        ],
      ),
    );
  }
}
