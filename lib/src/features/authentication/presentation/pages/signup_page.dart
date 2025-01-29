import 'package:flutter/material.dart';
import 'package:lishe_app2/src/features/authentication/presentation/pages/verification.dart';
import 'package:lishe_app2/src/features/authentication/presentation/widgets/text_field_widget.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/logo.png'),
              Text("LISHE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 32),
              CustomTextField(
                label: "Username",
                leadingicon: Icon(
                  Icons.person_2_outlined,
                  color: Colors.grey,
                ),
                hintText: "Enter Username",
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: "Email address or Phone Number",
                leadingicon: Icon(
                  Icons.contact_page,
                  color: Colors.grey,
                ),
                hintText: "Enter Email or Mobile Number",
              ),
              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerificationPage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.blue,
                    ),
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
                    "Send",
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
    );
  }
}
