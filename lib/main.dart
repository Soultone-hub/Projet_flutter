import 'package:flutter/material.dart';

void main() {
  runApp(MonApp());
}

class MonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'monapp',
      debugShowCheckedModeBanner: false,
      home: lesson(),
    );
  }
}

class lesson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xFFFDF0F3),
      body: SafeArea(
        child:SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.grid_view_rounded, size:30),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.notifications_none),
                    )
                 
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  "Upcomming courses",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                buildPromoBanner(),

                const SizedBox(height: 25),

                const Text(
                  "Catégories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                buildCategoriesRow(),
              ],
            ),
        ),
        ),
        bottomNavigationBar: buildBottomNAv(),
    );
  }
  Widget buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10, bottom: 0,
            child: Icon(Icons.school, size: 100, color: Colors.blue.withValues(alpha:0.2)),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("MEGA", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                Text("SALE", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red)),
                Text("60% OFF", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget buildCategoriesRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      categoryItem("Design", Icons.brush, Colors.orange),
      categoryItem("Web", Icons.code, Colors.pink),
      categoryItem("Microsoft", Icons.computer, Colors.blue),
    ],
  );
}


Widget categoryItem(String title, IconData icon, Color color) {
  return Container(
    width: 85,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
Widget buildBottomNAv() {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.redAccent,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.play_circle_outline),
        label: 'COurses',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Profile',
      ),
    ],
  );
}
}