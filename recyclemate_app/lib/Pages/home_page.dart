import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/routes.dart';

class HomePageDummy extends StatefulWidget {
  const HomePageDummy({Key? key}) : super(key: key);

  @override
  State<HomePageDummy> createState() => _HomePageDummyState();
}

class _HomePageDummyState extends State<HomePageDummy> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      _user = _auth.currentUser;
    });
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signOut();
      
      // Navigate back to login page after sign out
      Navigator.pushNamed(context, Routes.OnStart);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 30),
              child: const Text(
                'Hi! HomePage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 125, 39, 39),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Display user email if available
            if (_user != null && _user!.email != null)
              Container(
                margin: EdgeInsets.only(bottom: 30),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Text(
                  'Logged in as: ${_user!.email}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            
            // Large sign out button
            Container(
              margin: EdgeInsets.only(top: 50),
              width: 200,
              child: ElevatedButton(
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: 8),
                          Text('Sign Out'),
                        ],
                      ),
                onPressed: _isLoading ? null : _signOut,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
            
            // Additional smaller sign out option
            SizedBox(height: 30),
            TextButton(
              onPressed: _signOut,
              child: Text(
                'Sign Out from here',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                ),
              ),
            ),
            
            // Status indicator
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              child: _isLoading
                  ? Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Signing out...', style: TextStyle(color: Colors.grey)),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
      
      // Floating Action Button for sign out (optional)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _signOut,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        icon: Icon(Icons.logout),
        label: Text('Sign Out'),
        heroTag: 'signOutFab',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}