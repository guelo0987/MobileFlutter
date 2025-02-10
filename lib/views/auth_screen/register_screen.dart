import 'package:flutter/material.dart';
import 'package:dartproyect/views/components/FormField.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifypasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 23,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 50),
                  MyTextFormField(
                    controller: nameController,
                    keyBoardType: TextInputType.name,
                    obscureText: false,
                    hintText: "Your Name",
                    labelText: "Name",
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 15),
                  MyTextFormField(
                    controller: emailController,
                    keyBoardType: TextInputType.emailAddress,
                    obscureText: false,
                    hintText: "user@example.com",
                    labelText: "Email",
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 15),
                  MyTextFormField(
                    controller: passwordController,
                    keyBoardType: TextInputType.visiblePassword,
                    obscureText: true,
                    hintText: "Password",
                    labelText: "Password",
                    prefixIcon: Icons.password_outlined,
                  ),
                  const SizedBox(height: 15),
                  MyTextFormField(
                    controller: verifypasswordController,
                    keyBoardType: TextInputType.visiblePassword,
                    obscureText: true,
                    hintText: "Confirm Password",
                    labelText: "Confirm Password",
                    prefixIcon: Icons.password_outlined,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Already have an account?"),
                        SizedBox(width: 10),
                        Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
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
