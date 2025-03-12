import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/signup_page.dart';
import 'package:lishe_app2/src/features/authentication/presentation/widgets/password_field.dart';
import 'package:lishe_app2/src/features/authentication/presentation/widgets/text_field_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // After creating account, navigate to age selection
      if (mounted && userCredential.user != null) {
        Navigator.pushNamed(context, '/age');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/images/logo.png'),
                      Text(
                        "LISHE",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Color.fromRGBO(20, 49, 26, 1),
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 24.0,
                          height: 2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      CustomTextField(
                        hintText: "Username or Email",
                        leadingicon: Icon(
                          Icons.person_2_outlined,
                          color: Colors.grey,
                        ),
                        fieldController: _emailController,
                      ),
                      SizedBox(height: 12.0),
                      CustomPasswordField(
                        hintText: "Password",
                        fieldController: _passwordController,
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          // "Forgot Password?" action here
                        },
                        child: Text(
                          "Forgot Password?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      SizedBox(height: 12),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _signIn,
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                                  padding: WidgetStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: _signUp,
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                              ),
                              child: Text(
                                "Create Account",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member?",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignupPage()));
                              // redirect to register page
                            },
                            child: Text(
                              "Register Now",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Or continue with",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(18)),
                            child: Image.asset(
                              'lib/assets/images/google.png',
                              height: 16,
                              width: 16,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(18)),
                            child: Icon(Icons.facebook,
                                color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
