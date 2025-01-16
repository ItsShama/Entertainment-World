import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'DetailScreen.dart'; // Import the DetailScreen

class SearchScreen extends StatefulWidget {
  final String query;

  SearchScreen({required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List movies = [];
  bool isLoading = true;
  bool isNoResults = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovies(widget.query);
  }

  Future<void> fetchMovies(String searchQuery) async {
    final url = 'https://api.tvmaze.com/search/shows?q=$searchQuery';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
        isLoading = false;
        isNoResults = movies.isEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  void _triggerSearch() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        isNoResults = false;
      });
      fetchMovies(searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: 1,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 3),
            Expanded(
              child: GestureDetector(
                onTap: _triggerSearch,
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
                            _triggerSearch();
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
          : isNoResults
              ? Center(
                  child: Text(
                    'No movies found.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
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
                            builder: (context) => DetailScreen(movie: movie),
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
      elevation: 5,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap, // Trigger the onTap to navigate to the DetailScreen
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 118, 230, 123),
                const Color.fromARGB(255, 229, 92, 51),
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
