import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// --- DONNÉES GLOBALES ---
final List<Map<String, dynamic>> globalCategories = [
  {"name": "Design", "icon": Icons.brush_outlined},
  {"name": "Web", "icon": Icons.code_rounded},
  {"name": "Microsoft", "icon": Icons.grid_view},
  {"name": "Flutter", "icon": Icons.flutter_dash},
];

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
        scaffoldBackgroundColor: const Color(0xFFFDF0F3),
      ),
      home: const MainNavigationController(),
    );
  }
}

class MainNavigationController extends StatefulWidget {
  const MainNavigationController({super.key});

  @override
  State<MainNavigationController> createState() => _MainNavigationControllerState();
}

class _MainNavigationControllerState extends State<MainNavigationController> {
  int _currentIndex = 0;
  String selectedCategory = "Web";
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  List<String> selectedSearchFilters = [];
  List<Map<String, dynamic>> favoriteCourses = [];

  final Map<String, List<Map<String, dynamic>>> coursesData = {
    "Web": [
      {"title": "Web Development", "instructor": "Syed Tanvir Ahmed", "price": "4000/-BDT", "duration": "12h 52m", "date": "24-03-2023"},
      {"title": "Back End Development", "instructor": "John Doe", "price": "7000/-BDT", "duration": "12h 52m", "date": "24-03-2023"},
    ],
    "Design": [
      {"title": "UI Design", "instructor": "John Doe", "price": "3000/-BDT", "duration": "12h 52m", "date": "24-03-2023"},
    ],
    "Flutter": [
      {"title": "Full Stack Web", "instructor": "John Doe", "price": "7000/-BDT", "duration": "12h 52m", "date": "24-03-2023"},
    ],
  };

  List<Map<String, dynamic>> getFilteredCourses() {
    List<Map<String, dynamic>> allCourses = [];
    coursesData.forEach((key, value) {
      for (var course in value) {
        allCourses.add({...course, 'category': key});
      }
    });

    return allCourses.where((course) {
      bool matchesSearch = course['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
          course['instructor'].toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedSearchFilters.isEmpty || selectedSearchFilters.contains(course['category']);
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _changeTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _homeView(),
            _searchView(),
            const Center(child: Text("My Courses")),
            _favoriteView(),
            const Center(child: Text("Profile")),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(currentIndex: _currentIndex, onTap: _changeTab),
    );
  }

  // --- VUE ACCUEIL ---
  Widget _homeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Icon(Icons.grid_view_rounded, size: 28), Icon(Icons.notifications_none_rounded, size: 28)],
          ),
          const SizedBox(height: 25),
          const AutoImageCarousel(),
          const SizedBox(height: 30),
          const SectionHeader(title: "Categories"),
          const SizedBox(height: 15),
          _buildCategoryList(),
          const SizedBox(height: 30),
          SectionHeader(title: "Upcoming Courses", showSeeAll: true, onSeeAllTap: () => _changeTab(1)),
          const SizedBox(height: 15),
          _buildCourseSlider(),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: globalCategories.map((cat) {
          return CategoryItem(
            title: cat['name'],
            icon: cat['icon'],
            isSelected: selectedCategory == cat['name'],
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final isFav = favoriteCourses.any((c) => c['title'] == course['title']);
          return CourseCard(
            course: course,
            isFavorite: isFav,
            onFavorite: () {
              setState(() {
                if (isFav) {
                  favoriteCourses.removeWhere((c) => c['title'] == course['title']);
                } else {
                  favoriteCourses.add(course);
                }
              });
            },
          );
        },
      ),
    );
  }

  // --- VUE RECHERCHE ---
  Widget _searchView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) => setState(() => searchQuery = value),
                        decoration: const InputDecoration(
                          hintText: "Search for anything",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () => setState(() {
                      selectedSearchFilters.clear();
                      searchController.clear();
                      searchQuery = "";
                    }),
                    child: Container(
                      height: 55, width: 55,
                      decoration: BoxDecoration(color: const Color(0xFFF25F5C), borderRadius: BorderRadius.circular(15)),
                      child: const Icon(Icons.refresh, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Top Searches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ["Web", "Flutter", "Design"].map((tag) => ActionChip(
                  label: Text(tag),
                  onPressed: () => setState(() {
                    searchController.text = tag;
                    searchQuery = tag;
                  }),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                )).toList(),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Filter by Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: globalCategories.length,
            itemBuilder: (context, index) {
              final catName = globalCategories[index]['name'];
              return CheckboxListTile(
                activeColor: const Color(0xFFF25F5C),
                title: Text(catName),
                value: selectedSearchFilters.contains(catName),
                onChanged: (val) {
                  setState(() {
                    val == true ? selectedSearchFilters.add(catName) : selectedSearchFilters.remove(catName);
                  });
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF25F5C),
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () => _showResultsSheet(getFilteredCourses()),
            child: const Text("SHOW RESULTS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  void _showResultsSheet(List<Map<String, dynamic>> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Text("${results.length} Résultat(s)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: results.isEmpty 
                ? const Center(child: Text("No courses found"))
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, i) => ListTile(
                      leading: const Icon(Icons.play_circle_fill, color: Color(0xFFF25F5C)),
                      title: Text(results[i]['title']),
                      subtitle: Text(results[i]['instructor']),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  // --- VUE FAVORIS ---
  Widget _favoriteView() {
    return Container(
      color: const Color(0xFFFDF0F3),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text("Favorite", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 20),
          Expanded(
            child: favoriteCourses.isEmpty
                ? const Center(child: Text("No favorites yet"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: favoriteCourses.length,
                    itemBuilder: (context, index) {
                      return FavoriteCard(
                        course: favoriteCourses[index],
                        onRemove: () => setState(() => favoriteCourses.removeAt(index)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// --- COMPOSANTS ---

class FavoriteCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final VoidCallback onRemove;

  const FavoriteCard({super.key, required this.course, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 85, height: 85,
              color: Colors.grey[200],
              child: const Icon(Icons.image, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis)),
                    GestureDetector(onTap: onRemove, child: const Icon(Icons.favorite, color: Colors.red, size: 20)),
                  ],
                ),
                Text(course['instructor'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(course['price'], style: const TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold, fontSize: 14)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Course added to cart!")),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE0E0), 
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Text("Buy", style: TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(course['duration'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    const SizedBox(width: 12),
                    const Icon(Icons.calendar_month, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(course['date'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const CourseCard({super.key, required this.course, required this.isFavorite, required this.onFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                child: Container(height: 130, width: double.infinity, color: Colors.grey[200], child: const Icon(Icons.image, size: 40, color: Colors.white)),
              ),
              Positioned(
                top: 10, right: 10,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(course['price'], style: const TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [const Icon(Icons.access_time, size: 14), const SizedBox(width: 4), Text(course['duration'], style: const TextStyle(fontSize: 11))]),
                    Text(course['date'], style: const TextStyle(fontSize: 11)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

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
        if (showSeeAll) GestureDetector(onTap: onSeeAllTap, child: const Text("See All", style: TextStyle(color: Color(0xFFF25F5C)))),
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
        child: Column(children: [Icon(icon), const SizedBox(height: 8), Text(title, style: const TextStyle(fontSize: 12))]),
      ),
    );
  }
}



class AutoImageCarousel extends StatefulWidget {
  const AutoImageCarousel({super.key});

  @override
  State<AutoImageCarousel> createState() => _AutoImageCarouselState();
}

class _AutoImageCarouselState extends State<AutoImageCarousel> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  
  final List<String> images = [
    'https://images.unsplash.com/photo-1501504905953-f83a699573f2?q=80&w=500',
    'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=500',
    'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=500',
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= images.length) nextPage = 0;
        
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    image: NetworkImage(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // LES POINTS INDICATEURS
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 20 : 8, // Le point actif est plus large
              decoration: BoxDecoration(
                color: _currentPage == index 
                    ? const Color(0xFFF25F5C) 
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}class CustomFooter extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomFooter({super.key, required this.currentIndex, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFF25F5C),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), activeIcon: Icon(Icons.play_circle), label: 'Courses'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), activeIcon: Icon(Icons.favorite), label: 'Favorite'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}