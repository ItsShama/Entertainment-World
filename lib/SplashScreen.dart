import 'package:flutter/material.dart';
import 'dart:async';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isNameVisible = false;

  @override
  void initState() {
    super.initState();

    // After 1 second, show the "Entertainment World" text and navigate to the home screen
    Timer(Duration(seconds: 1), () {
      setState(() {
        _isNameVisible = true;
      });

      // Navigate to HomeScreen after 1 second
      Timer(Duration(seconds: 1), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isNameVisible)
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Color(0xFFFFC107), // Starting gradient color
                      Color(0xFFE50914), // Ending gradient color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.2, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  'Entertainment World',
                  style: TextStyle(
                    fontSize: 40, // Larger font size
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic, // Italic font style
                    color:
                        Colors.white, // Default color before shader is applied
                  ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
