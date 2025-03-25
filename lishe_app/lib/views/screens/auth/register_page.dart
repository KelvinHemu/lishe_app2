import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/auth/custom_text_field.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _sendVerification() async {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(authProvider.notifier);

      try {
        final username = _usernameController.text.trim();
        final phoneNumber = _contactController.text.trim();

        final success = await authNotifier.initiateRegistration(
          username,
          phoneNumber,
        );
        // Navigate to the OTP verification page on success
        if (success && mounted) {
          context.go(
            '/verification',
            extra: {'username': username, 'contact': phoneNumber},
          );
        }
      } catch (e) {
        // Handle errors (already managed in AuthNotifier)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  AppBar().preferredSize.height,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 80,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.eco,
                          size: 80,
                          color: Color.fromRGBO(20, 49, 26, 1),
                        ),
                  ),
                  const Text(
                    "LISHE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromRGBO(20, 49, 26, 1),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Username",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Enter Username",
                        leadingicon: const Icon(
                          Icons.person_2_outlined,
                          color: Colors.grey,
                        ),
                        fieldController: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Phone Number field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Phone Number",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        hintText: "Enter Phone Number",
                        leadingicon: const Icon(
                          Icons.contact_page,
                          color: Colors.grey,
                        ),
                        fieldController: _contactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          // Remove all spaces from the phone number
                          String formattedValue = value.replaceAll(' ', '');
                          // Replace +255 with 0 at the beginning if present
                          if (formattedValue.startsWith('+255')) {
                            formattedValue = '0${formattedValue.substring(4)}';
                          }
                          
                          bool isPhone = RegExp(
                            r'^[0-9]{10,15}$',
                          ).hasMatch(formattedValue);
                          if (!isPhone) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  if (authState.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        authState.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  const SizedBox(height: 32),

                  // Send button
                  SizedBox(
                    width: double.infinity,
                    child:
                        authState.status == AuthStatus.loading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                              onPressed: _sendVerification,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Send",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                  ),

                  const SizedBox(height: 24),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
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
