import 'package:flutter/material.dart';
import 'package:dartproyect/views/components/FormField.dart';
import 'package:dartproyect/controllers/AuthController.dart';
import 'package:dartproyect/services/manage_http_response.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verifypasswordController =
      TextEditingController();

  final AuthController _authController = AuthController();
  bool _isLoading = false;

  void _showSnackBar(String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (passwordController.text != verifypasswordController.text) {
      _showSnackBar('Las contraseñas no coinciden', true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authController.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (response.success) {
        _showSnackBar(response.message ?? 'Registro exitoso', false);
        Navigator.pop(context);
      } else {
        _showSnackBar(
            response.message ??
                ManageHttpResponse.getErrorMessage(response.statusCode),
            true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Error de conexión: $e', true);
    }
  }

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
                  const Text(
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
                    onTap: _isLoading ? null : _handleRegister,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _isLoading ? Colors.grey : Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
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
                    onTap: () => Navigator.pop(context),
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    verifypasswordController.dispose();
    super.dispose();
  }
}
