import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For AppBar's icon

class DetailScreen extends StatelessWidget {
  final Map movie; // Receive movie data passed from the previous screen

  // Constructor to receive movie data
  DetailScreen({required this.movie});

  final TextEditingController searchController =
      TextEditingController(); // Controller for search

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 1,
        title: Row(
          children: [
            // Home button in the AppBar
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        '/')); // Navigate back to the HomeScreen
              },
            ),
            SizedBox(width: 10),

            // Search Bar similar to HomeScreen
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Your search action
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.black),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search movies...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) {
                            // Trigger search
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle
            .light, // Make sure the status bar icons are visible
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            // Movie Image
            Image.network(
              movie['image']?['original'] ?? 'https://via.placeholder.com/400',
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),

            // Movie Title
            Text(
              movie['name'] ?? 'Unknown Title',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),

            // Movie Summary
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                    'No summary available.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 20),

            // You can add more information here, e.g., genres, rating, etc.
            movie['genres'] != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Genres:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        movie['genres'].join(', ') ?? 'No genres available',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 15),
                    ],
                  )
                : SizedBox(),

            // Rating if available
            movie['rating'] != null
                ? Row(
                    children: [
                      Text(
                        'Rating: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        movie['rating']['average']?.toString() ?? 'No rating',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
