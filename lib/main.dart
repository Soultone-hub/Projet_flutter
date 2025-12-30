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
            child: Icon(Icons.school, size: 80, color: Colors.white70),
          )
        ],
      ),
    );
  }

}