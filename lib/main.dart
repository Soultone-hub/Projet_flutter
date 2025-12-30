import 'package:flutter/material.dart';

void main() {
  // ICI : On lance MyApp et non MonApp directement
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course App',
      theme: ThemeData(fontFamily: 'Poppins'),
      // ICI : MyApp appelle le contrôleur de navigation
      home: const MonApp(), 
    );
  }
}

class MonApp extends StatefulWidget {
  const MonApp({super.key});
  @override
  State<MonApp> createState() => _MonAppState();
}

class _MonAppState extends State<MonApp>{
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState(){
    super.initState();
    _pages = [
      homeView(),      // Index 0
      searchView(),    // Index 1
      const Center(child: Text("My Courses")), // Index 2
      favoriteView(),  // Index 3
      const Center(child: Text("Profile")),    // Index 4
    ];
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      backgroundColor: const Color(0xFFFDF0F3), 
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: buildFooter(),
    );
  }

 
  Widget buildFooter(){
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.play_circle_outline), label: 'CCourses'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorites'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  

  Widget homeView() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: const [Icon(Icons.grid_view_rounded, size: 28), Icon(Icons.notifications_none_rounded, size: 28)]
        ),
        const SizedBox(height: 25),

        Container(
          height: 160, 
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF003D4C), // Bleu foncé du modèle
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Center(child: Text("Bannière Promo (Stack)", style: TextStyle(color: Colors.white))),
        ),
        const SizedBox(height: 30),

        buildSectionHeader("Categories"),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              buildCategoryItem("Design", Icons.brush_outlined),
              buildCategoryItem("Web", Icons.code_rounded, isSelected: true), // État Web sélectionné
              buildCategoryItem("Microsoft", Icons.grid_view),
              buildCategoryItem("Flutter", Icons.flutter_dash),
            ],
          ),
        ),
        const SizedBox(height: 30),

        buildSectionHeader("Upcoming Courses", showSeeAll: true),
        const SizedBox(height: 15),
        Container(height: 250, color: Colors.transparent, child: const Center(child: Text("Zone des Cartes"))),
        SizedBox(
            height: 260, // Hauteur fixe pour la liste horizontale
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: coursesData[selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                final course = coursesData[selectedCategory]![index];
                return buildCourseCard(course);
              },
  ),
),
      ],
      
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
          Container(height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15))), 
          const SizedBox(height: 20),
          const Text("Top Searches", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(spacing: 10, children: List.generate(3, (i) => Container(width: 80, height: 35, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))))),
          const SizedBox(height: 25),
          const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: ListView.builder(itemCount: 5, itemBuilder: (context, index) => ListTile(leading: const Icon(Icons.check_box_outline_blank), title: Container(height: 10, color: Colors.grey[300])))),
          Container(height: 55, width: double.infinity, decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(15)), child: const Center(child: Text("SHOW RESULTS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget favoriteView() {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text("Favorite", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              height: 100,
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
      ],
    );
  }
  Widget buildSectionHeader(String title, {bool showSeeAll = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      if (showSeeAll)
        const Text(
          "See all",
          style: TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold),
        ),
    ],
  );
}
Widget buildCategoryItem(String title, IconData icon, {bool isSelected = false}) {
  return Container(
    width: 85,
    margin: const EdgeInsets.only(right: 15),
    padding: const EdgeInsets.symmetric(vertical: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      // Bordure uniquement si sélectionné
      border: isSelected 
          ? Border.all(color: const Color(0xFFF25F5C).withOpacity(0.2), width: 2) 
          : null,
      boxShadow: [
        if (!isSelected) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)
      ],
    ),
    child: Column(
      children: [
        Icon(
          icon, 
          color: isSelected ? const Color(0xFFF25F5C) : Colors.black87, 
          size: 28
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFFF25F5C) : Colors.black54,
          ),
        ),
      ],
    ),
  );
}

Widget buildCourseCard(Map<String, dynamic> course) {
  return Container(
    width: 260,
    margin: const EdgeInsets.only(right: 20, bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- PARTIE HAUTE (Image + Avatar Prof) ---
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              child: Container(
                height: 130,
                width: double.infinity,
                color: Colors.grey[300], // Remplacé par Image.network(course['image']) plus tard
                child: const Icon(Icons.image, color: Colors.white, size: 40),
              ),
            ),
            // Badge du Professeur qui "flotte"
            Positioned(
              bottom: -15,
              left: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                    const SizedBox(width: 6),
                    Text(course['instructor'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
        // --- PARTIE BASSE (Infos) ---
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 5),
              Text(course['price'], style: const TextStyle(color: Color(0xFFF25F5C), fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(course['duration'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ]),
                  Row(children: [
                    const Icon(Icons.calendar_month_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(course['date'], style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
// 1. Définis tes données (Exemple)
final Map<String, List<Map<String, dynamic>>> coursesData = {
  "Web": [
    {"title": "Web Development", "instructor": "John Doe", "price": "8500/-BDT", "duration": "12h 52m", "date": "24-03-2023"},
    {"title": "React Basics", "instructor": "Sarah W.", "price": "5500/-BDT", "duration": "08h 20m", "date": "12-04-2023"},
  ],
  "Design": [
    {"title": "UI/UX Design", "instructor": "Jane Smith", "price": "7000/-BDT", "duration": "15h 30m", "date": "01-05-2023"},
  ],
};

String selectedCategory = "Web"; // Catégorie par défaut

}