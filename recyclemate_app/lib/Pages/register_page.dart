import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

import 'package:email_validator/email_validator.dart';
import '../services/utils.dart';
import '../services/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  

  @override
  void dispose() {
    
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }



  // Sign Up function and validation.
  Future signUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    //Check passoword.
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Utils.showSnackBar(context, 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Store username in Firebase Auth Profile
      await userCredential.user?.updateDisplayName(usernameController.text.trim());

      // Store user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      Navigator.pushReplacementNamed(context, Routes.HomePageDummy);
      
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak. Use a stronger password.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
      
      Utils.showSnackBar(context, errorMessage);
      
    } catch (e) {
      String errorMessage = 'An unexpected error occurred.';
      setState(() {
        _errorMessage = errorMessage;
      });
      Utils.showSnackBar(context, errorMessage);
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
      body: Container( //Background Gradient Color.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 39, 176, 39), 
              Color.fromARGB(255, 211, 155, 71), 
            ],
          ),
        ),
            child: SingleChildScrollView(
              child: Column(
                children: [
              
                  // Icon Register Section
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person_add,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
              
                        SizedBox(height: 30),
              
                        // Create an Account Text.
                        Text(
                          'Create an Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              
                        SizedBox(height: 10),
              
                        // Description text.
                        Text(
                          'Join RecycleMate and start your\nsustainability journey!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // User input section.
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
              
                          // Error Message if there is an error
                          if (_errorMessage != null)
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
              
                          //Username Input.
                          Container(
                          width: 380,
                          child: TextFormField(
                            controller: usernameController,
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.redAccent, 
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.account_circle_sharp,
                                color: Colors.white,
                              ),
                            ),
                            
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.isEmpty 
                                ? 'Please enter a username' 
                                : null,
                          )
                        ),
              
                          SizedBox(height: 20),
              
                          // Email User Input.
                          Container(
                          width: 380,
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.redAccent, 
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                              hintText: 'Email address',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? 'Please enter a valid email'
                                    : null,
                          )
                        ),
                        
                        SizedBox(height: 20),
                          
                        // Password User Input. 
                        Container(
                          width: 380,
                          child: TextFormField(
                            controller: passwordController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            obscureText: _obscurePassword,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.redAccent, 
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.length < 8
                                ? 'Password must be at least 8 characters'
                                : null,
                          )
                        ),
                          
                        SizedBox(height: 20),
                          
                        // Confirm Password User Input.
                        TextFormField(
                            controller: confirmPasswordController,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            obscureText: _obscureConfirmPassword,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.white, 
                                  width: 2,
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.redAccent, 
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                              hintText: 'Confirm password',
                              hintStyle: TextStyle(
                                color: Colors.white,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Password do not match';
                              }
                              return null;
                            },
                          ),
              
                        SizedBox(height: 30),
                          
                        // Create an account Button.
                        Container(
                            width: 380,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : signUp,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blueAccent,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal:60 ,vertical : 16),
                                textStyle:TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black.withOpacity(0.5),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blueAccent,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "Create Account",
                                      ),
                                    ),
                            ),
                          
                          
                        SizedBox(height: 25),
                          
                        // Horizontal Line Divider.
                        Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.white.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          
                        SizedBox(height: 25),
                          
                        // Already have account text.
                        RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Log In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, Routes.LoginPage);
                                    },
                                )
                              ],
                            ),
                          ),
                          
                        SizedBox(height: 40),
                          
                        // Terms and Conditions
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'By creating an account, you agree to our Terms of Service and Privacy Policy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
  }
}