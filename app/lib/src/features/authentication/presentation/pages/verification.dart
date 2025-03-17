import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/create_password.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    // Dispose of controllers and focus nodes to free up resources.
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      // Automatically move to the next field.
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move back if the field is cleared.
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Veryifying Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Column(
              children: [
                const Text(
                  "Enter Verification Code",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text(
                  "A 4-digit code was sent to",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "+255 700 011",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 50,
                      height: 50,
                      child: TextField(
                        controller: _controllers[index],
                        cursorColor: Colors.blue,
                        cursorHeight: 32,
                        cursorWidth: 3,
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 56, 56, 56),
                        ),
                        decoration: InputDecoration(
                          counterText: "", // Hides maxLength counter
                          filled: true,
                          fillColor: _controllers[index].text.isNotEmpty
                              ? const Color.fromARGB(255, 248, 243, 243)
                              : const Color.fromARGB(255, 255, 255, 255),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                                style: BorderStyle.solid),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                  style: BorderStyle.solid)),
                          contentPadding: EdgeInsets.zero, // Removes padding
                        ),
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                Text(
                  " Resend Code",
                  style: TextStyle(color: Colors.blue),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      String otp = _controllers.map((e) => e.text).join();
                      if (kDebugMode) {
                        print("Entered OTP: $otp");
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CreatePassword()));
                      // redirect to register page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Verify",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
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
