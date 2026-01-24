
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'routes.dart';



class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  
  /*final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }
  */

  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var rememberMe= false;
  
  //FIREBASE AUTHENTICATION
  /*String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
        );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text, 
        password: _controllerPassword.text,
        );
    } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
      });
    }
  }
*/



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: 
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF004E92), // #71B280
                  Color(0xFF000428), // #134E5E
    
                ],
                // For a different angle, you can use:
                // begin: Alignment.topCenter,
                // end: Alignment.bottomCenter,
                // For diagonal gradient:
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container( // TEXT HEY THERE!-------------------------------------------------------------------------------------------
                  margin: const EdgeInsets.only(top: 150.0),
                  child: const Text(
                    'Hey there!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container( // TEXT WELCOME BACK-------------------------------------------------------------------------------------------
                  margin: const EdgeInsets.only(bottom:70.0),
                  child: const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container( // USERNAME INPUT-------------------------------------------------------------------------------------------
                  width: 380,
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.white, width: 2) 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.white, width: 3)
                      ),
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                Container( //PASSWORD INPUT-------------------------------------------------------------------------------------------
                  width: 380,
                  margin: EdgeInsets.only(top: 30),
                    child: TextFormField(
                      style: TextStyle(
                      color: Colors.white,
                    ),
                    obscureText: true,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.white, width: 2)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide(color: Colors.white, width: 3)
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Row(// REMEMBER ME CHECKBOX AND FORGOT PASSWORD---------------------------------------------------------------------
                  children: [
                    SizedBox(width: 12),
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = false;
                        });
                      },
                      checkColor: Colors.white, // Color of the check icon
                      fillColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.black; // Background when checked
                        }
                        return Colors.white; // Background when unchecked
                      }),
                    ),
                    Text(
                      "Remember me",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                  TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, Routes.ForgetPassword);
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 15)
                  ],
                ),

                Container( //BUTTON LOGIN-------------------------------------------------------------------------------------------
                  margin: const EdgeInsets.only(top:50),

                  width: 380,
                  child: ElevatedButton(
                    child: const Text("Login"),
                    onPressed: (){
                    },
                    style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 13),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(7),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.5)
                    ),
                  ),
                ),
                Container(// SIGN UP HYPERLINK
                  margin: EdgeInsets.only(top: 15, bottom: 30),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Do not have an account yet? ',
                          style: TextStyle (
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, Routes.RegisterPage);
                            print('Sign Up Tapped');
                          }
                        )
                      ]
                    )
                  )
                ),
                SizedBox(
                  width: 350, // Set your desired width
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(// GOOGLE BUTTON
                  margin: const EdgeInsets.only(top:40),
                  width: 350,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'lib/images/googleIcon.png', 
                          height: 24,
                          width: 24,
                        ),
                        SizedBox(width: 12), 
                        const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16, 
                          ),
                        ),
                      ],
                    ),
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        
                      ),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.5)
                    ),
                  ),
                )
            ],
          ),
        ),
    ));
  }
}
