import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../services/routes.dart';

class HomePageDummy extends StatefulWidget {
  const HomePageDummy({super.key});

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
    _user = _auth.currentUser;
  }

  Future<void> _signOut() async {
    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, Routes.OnStart, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out successfully'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Home', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _signOut, tooltip: 'Sign Out'),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Real-time Username Display using StreamBuilder
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error loading name");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Extract username from the Firestore document
                String displayName = "User";
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                  displayName = data['username'] ?? "User";
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Hi, $displayName!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color.fromARGB(255, 39, 176, 39),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: const Text(
                'Welcome to RecycleMate',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
            
            if (_user != null && _user!.email != null)
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue[100]!),
                ),
                child: Text(
                  'Logged in as: ${_user!.email}',
                  style: TextStyle(fontSize: 14, color: Colors.blue[800]),
                ),
              ),
            
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signOut,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, size: 20),
                          SizedBox(width: 8),
                          Text('Sign Out'),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _signOut,
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.logout),
        label: const Text('Quick Logout'),
        heroTag: 'signOutFab',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}