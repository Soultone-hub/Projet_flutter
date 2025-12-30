import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const MainNavigationController(),
    );
  }
}

// --- LE CONTRÔLEUR DE NAVIGATION ---
class MainNavigationController extends StatefulWidget {
  const MainNavigationController({super.key});

  @override
  State<MainNavigationController> createState() => _MainNavigationControllerState();
}

class _MainNavigationControllerState extends State<MainNavigationController> {
  int _currentIndex = 0;
  String selectedCategory = "Web"; // Catégorie par défaut
  List<String> selectedSearchFilters = [];
  final Map<String, List<Map<String, dynamic>>> coursesData = {
    "Web": [
      {"title": "Web Development", "instructor": "John Doe", "price": "8500/-BDT", "duration": "12h 52m", "date": "24-03-2023"},
      {"title": "React Basics", "instructor": "Sarah W.", "price": "5500/-BDT", "duration": "08h 20m", "date": "12-04-2023"},
    ],
    "Design": [
      {"title": "UI/UX Design", "instructor": "Jane Smith", "price": "7000/-BDT", "duration": "15h 30m", "date": "01-05-2023"},
    ],
    "Flutter": [
      {"title": "Flutter Mastery", "instructor": "Alex H.", "price": "9000/-BDT", "duration": "20h 15m", "date": "10-06-2023"},
    ],
  };

  void _changeTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F3),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _homeView(),
            searchView(),
            const Center(child: Text("My Courses")),
            const Center(child: Text("Favorite View")),
            const Center(child: Text("Profile")),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(currentIndex: _currentIndex, onTap: _changeTab),
    );
  }

  // --- VUE ACCUEIL (HOME) ---
  Widget _homeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.grid_view_rounded, size: 28),
              Icon(Icons.notifications_none_rounded, size: 28),
            ],
          ),
          const SizedBox(height: 25),

          // Carrousel Automatique
          const AutoImageCarousel(),
          const SizedBox(height: 30),

          // Section Catégories
          const SectionHeader(title: "Categories"),
          const SizedBox(height: 15),
          _buildCategoryList(),
          const SizedBox(height: 30),

          // Section Cours
          SectionHeader(
            title: "Upcoming Courses",
            showSeeAll: true,
            onSeeAllTap: () => _changeTab(1), // Envoie vers Search
          ),
          const SizedBox(height: 15),
          _buildCourseSlider(),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    final List<Map<String, dynamic>> categories = [
      {"name": "Design", "icon": Icons.brush_outlined},
      {"name": "Web", "icon": Icons.code_rounded},
      {"name": "Microsoft", "icon": Icons.grid_view},
      {"name": "Flutter", "icon": Icons.flutter_dash},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final bool isSelected = selectedCategory == cat['name'];
          return CategoryItem(
            title: cat['name'],
            icon: cat['icon'],
            isSelected: isSelected,
            onTap: () => setState(() => selectedCategory = cat['name']),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCourseSlider() {

    final courses = coursesData[selectedCategory] ?? [];
    return SizedBox(
      height: 285,
      child: courses.isEmpty
          ? const Center(child: Text("No courses found"))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              itemBuilder: (context, index) => CourseCard(course: courses[index]),
            ),
    );
  }

  Widget searchView() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // BARRE DE RECHERCHE
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search for anything",
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Container(
              height: 55, width: 55,
              decoration: BoxDecoration(color: const Color(0xFFF25F5C), borderRadius: BorderRadius.circular(15)),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ],
        ),

        const SizedBox(height: 30),
        const Text("Top Searches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),

        // TAGS STATIQUES (Exemples)
        Wrap(
          spacing: 10,
          children: ["Web Design", "Flutter", "UX"].map((tag) => Chip(
            label: Text(tag, style: const TextStyle(fontSize: 12)),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )).toList(),
        ),

        const SizedBox(height: 30),
        const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        
        // --- SYNCHRONISATION AUTOMATIQUE ICI ---
        Expanded(
          child: ListView.builder(
            itemCount: globalCategories.length, // Utilise ta liste globale
            itemBuilder: (context, index) {
              final catName = globalCategories[index]['name'];
              final isChecked = selectedSearchFilters.contains(catName);

              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(catName, style: const TextStyle(fontSize: 15)),
                value: isChecked,
                activeColor: const Color(0xFFF25F5C),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedSearchFilters.add(catName);
                    } else {
                      selectedSearchFilters.remove(catName);
                    }
                  });
                },
              );
            },
          ),
        ),

        // BOUTON DE RÉSULTATS
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF25F5C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                print("Filtres sélectionnés : $selectedSearchFilters");
                // Ici tu pourras filtrer tes cours
              },
              child: const Text("SHOW RESULTS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    ),
  );
}}


// --- COMPOSANT : CARROUSEL AUTO ---
class AutoImageCarousel extends StatefulWidget {
  const AutoImageCarousel({super.key});

  @override
  State<AutoImageCarousel> createState() => _AutoImageCarouselState();
}

class _AutoImageCarouselState extends State<AutoImageCarousel> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;
  final List<String> images = [
    'https://images.unsplash.com/photo-1501504905953-f83a699573f2?q=80&w=500',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=500',
    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=500',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage < images.length - 1) ? _currentPage + 1 : 0;
        _controller.animateToPage(_currentPage, duration: const Duration(milliseconds: 350), curve: Curves.easeIn);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: images.length,
            itemBuilder: (context, i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(image: NetworkImage(images[i]), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _currentPage == i ? 20 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: _currentPage == i ? const Color(0xFFF25F5C) : Colors.black12,
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ),
      ],
    );
  }
}

// --- COMPOSANT : CARTE DE COURS ---
class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: Container(height: 130, color: Colors.grey[200], child: const Icon(Icons.image, size: 40, color: Colors.white)),
              ),
              Positioned(
                bottom: -15, left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)]),
                  child: Row(children: [
                    const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                    const SizedBox(width: 8),
                    Text(course['instructor'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(course['price'], style: const TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoLabel(Icons.access_time, course['duration']),
                    _infoLabel(Icons.calendar_month, course['date']),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLabel(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 14, color: Colors.grey), const SizedBox(width: 4), Text(text, style: const TextStyle(color: Colors.grey, fontSize: 11))]);
  }
}

// --- COMPOSANTS UI MINEURS ---
class SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;
  const SectionHeader({super.key, required this.title, this.showSeeAll = false, this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (showSeeAll)
          GestureDetector(onTap: onSeeAllTap, child: const Text("See All", style: TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold))),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  const CategoryItem({super.key, required this.title, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85, margin: const EdgeInsets.only(right: 15), padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: const Color(0xFFF25F5C), width: 2) : null,
        ),
        child: Column(children: [
          Icon(icon, color: isSelected ? const Color(0xFFF25F5C) : Colors.black87, size: 28),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ]),
      ),
    );
  }
}

class CustomFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomFooter({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          currentIndex: currentIndex, onTap: onTap, type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.redAccent, unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorite'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> globalCategories = [
  {"name": "Design", "icon": Icons.brush_outlined},
  {"name": "Web", "icon": Icons.code_rounded},
  {"name": "Microsoft", "icon": Icons.grid_view},
  {"name": "Flutter", "icon": Icons.flutter_dash},
];

