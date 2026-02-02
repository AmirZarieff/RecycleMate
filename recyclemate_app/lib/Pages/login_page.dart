import '../services/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:recyclemate_app/Pages/forget_password.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //Initialize variable for form validation and sign in authentication.
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  

  // Firebase authentication, validation and sign in.
  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      
      
      Navigator.pushNamed(context, Routes.HomePageDummy);
      
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your internet connection.';
          break;
        default:
          errorMessage = 'Authentication failed. Please check your credentials.';
      }
      
      setState(() {
        _errorMessage = errorMessage;
      });
      
      // Optionally show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } on FirebaseException catch (e) {

    // Handle other Firebase-specific errors.
    setState(() {
      _errorMessage = 'Firebase error: ${e.message}';
    }); 
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Cleans up resources to prevent memory leaks, cancels any ongoing operations and releases system resources.
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Designing the login page screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( //Background Gradient Colors.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 39, 176, 39),
              Color(0xFF2196F3),
            ],
          ),
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                // Icon header.
                Container(
                  margin: EdgeInsets.only(top: 100),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 2)
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 50,
                    color: Colors.white,
                  ),
                ),

                // Hey there! text display.
                Container( 
                  margin: const EdgeInsets.only(top: 20.0),
                  child: const Text(
                    'Hey there!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),

                // Welcome Back text display.
                Container( 
                  margin: const EdgeInsets.only(bottom: 50.0),
                  child: const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Error message display if the user throws an error.
                if (_errorMessage != null)
                  Container(
                    width: 380,
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Email User input.
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
                              ? 'Please enter a valid email!'
                              : null,
                    ),
                  ),

                // Password Input User.  
                Container( 
                  width: 380,
                  margin: EdgeInsets.only(top: 20),
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
                        color: Colors.white, // Keep white border even in error
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white, // Keep white border even in focused error
                        width: 2,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.redAccent, // White text for error message
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
                  ),
                ),
                SizedBox(height: 5),

                //Forgot Password Text Button.
                Row(//
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPassword()),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),

                // Login Button.
                Container( 
                  margin: const EdgeInsets.only(top: 30),
                  width: 380,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : signIn,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                      backgroundColor: Colors.white,
                      padding:
                        EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                      textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(7),
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Login"),
                  ),
                ),
                SizedBox(height: 30),

                // OR divider.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 160, 
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
                      Container(
                        width: 160, 
                        child: Divider(
                          color: Colors.white.withOpacity(0.3),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),

                // Does not have an account yet text button.
                Container( 
                  margin: EdgeInsets.only(top: 25, bottom: 30),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Do not have an account yet? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        TextSpan(
                          text: 'Create an account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, Routes.RegisterPage);
                              print('Sign Up Tapped');
                            },
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // TOS & PP.
                Text(
                  'By signing in, you agree to our Terms of Service\nand Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}