import 'package:flutter/material.dart';
import '../services/routes.dart';

class OnStart extends StatefulWidget {
  const OnStart({super.key});

  @override
  State<OnStart> createState() => _OnStartState();
}

class _OnStartState extends State<OnStart> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Mini Pages Setup.
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Welcome to RecycleMate',
      'description': 'Your smart recycling companion that makes sustainability simple and rewarding.',
      'icon': Icons.eco,
      'color': Color(0xFF4CAF50), // Green
    },
    {
      'title': 'Smart Waste Sorting',
      'description': 'Scan items with your camera and get instant recycling instructions.',
      'icon': Icons.camera_alt,
      'color': Color(0xFF2196F3), // Blue
    },
    {
      'title': 'Earn Eco-Points',
      'description': 'Get rewarded for recycling and redeem points for exciting gifts.',
      'icon': Icons.card_giftcard,
      'color': Color(0xFF9C27B0), // Purple
    },
    {
      'title': 'Track Your Impact',
      'description': 'See how your recycling efforts contribute to a greener planet.',
      'icon': Icons.trending_up,
      'color': Color(0xFFFF9800), // Orange
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _pages[_currentPage]['color'],
              _pages[_currentPage]['color'].withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  // Mini Pages Content.
  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: Icon(
              page['icon'],
              size: 70,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40),
          Text(
            page['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              page['description'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bottom side including dot and next button as well as the skip.
  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 40.0,
        top: 50.0, 
        bottom: 80.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                width: _currentPage == index ? 25 : 10,
                height: 10,
                margin: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? Colors.white 
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          SizedBox(height: 70),
          
          // Next/Get Started button.
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _pages.length - 1) {
                  Navigator.pushReplacementNamed(context, Routes.RegisterPage);
                } else {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: _pages[_currentPage]['color'],
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Text(
                _currentPage == _pages.length - 1 ? 'GET STARTED' : 'NEXT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          SizedBox(height: 15),
          
          // Skip/Sign In button.
          if (_currentPage < _pages.length - 1)
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.LoginPage);
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          if (_currentPage == _pages.length - 1)
            Padding(
              padding: EdgeInsets.only(top: 10), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.LoginPage);
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}