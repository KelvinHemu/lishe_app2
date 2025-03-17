import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/age.dart';
import 'package:lishe_app2/src/features/authentication/presentation/widgets/password_field.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({super.key});

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final passController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Constants for repeated styles
    const Color primaryColor = Colors.blue;
    const Color warningColor = Color.fromARGB(255, 180, 124, 12);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Create Password",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        elevation: 0, // Remove app bar shadow for cleaner UI
        iconTheme: const IconThemeData(
            color: Colors.black), // Ensure back icon is visible
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Create Password",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 40),
                CustomPasswordField(
                  hintText: "Enter a new password",
                  fieldController: passController,
                ),
                const SizedBox(height: 20),
                CustomPasswordField(
                  hintText: "Confirm your password",
                  fieldController: confirmController,
                ),
                const SizedBox(height: 10),
                const Text(
                  "• Passwords must be at least six characters",
                  style: TextStyle(
                    color: warningColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add proper navigation logic here
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AgeSelection())); // Navigate to the previous page or next step
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
