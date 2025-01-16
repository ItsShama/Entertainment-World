import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'SearchScreen.dart';
import 'DetailScreen.dart'; // Import the Details Screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];
  bool isLoading = true;
  TextEditingController searchController =
      TextEditingController(); // Controller to manage search input

  @override
  void initState() {
    super.initState();
    fetchMovies(); // Fetch movies on HomeScreen load
  }

  // Fetch movies from API
  Future<void> fetchMovies() async {
    final url = 'https://api.tvmaze.com/search/shows?q=all';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Function to trigger search screen
  void _navigateToSearchScreen() {
    if (searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(query: searchController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Body background set to black
      appBar: AppBar(
        leadingWidth: 1,
        title: Row(
          children: [
            // App name on the left
            Text(
              'Entertainment World',
              style: TextStyle(
                color: Color(0xFFE50914), // White color for the app name
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(width: 30), // Added space between app name and search bar

            // Search Bar with padding and margin
            Expanded(
              // Use Expanded to make the search bar take remaining space
              child: GestureDetector(
                onTap: _navigateToSearchScreen, // Trigger search on tap
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
                            // Trigger search when Enter is pressed
                            _navigateToSearchScreen();
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index]['show'];
                return MovieCard(
                  movie: movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            movie:
                                movie), // Navigate with data to DetailsScreen
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map movie;
  final VoidCallback onTap;

  const MovieCard({required this.movie, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      elevation: 5, // Optional to add shadow
      color: Colors.transparent, // No fixed card color
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(
                    255, 118, 230, 123), // Start with a darker blue
                const Color.fromARGB(255, 229, 92, 51), // Lighter blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                movie['image']?['medium'] ?? 'https://via.placeholder.com/150',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie['name'] ?? 'N/A',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  movie['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ??
                      'No summary available',
                  style: TextStyle(color: Colors.white70),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
