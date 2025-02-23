import 'package:dartproyect/views/auth_screen/register_screen.dart';
import 'package:dartproyect/views/components/FormField.dart';
import 'package:dartproyect/controllers/AuthController.dart';
import 'package:dartproyect/services/manage_http_response.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    try {
      final response = await _authController.login(
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() => _isLoading = false);

      if (!mounted) return;

      if (response.success) {
        _showSnackBar(response.message ?? 'Inicio de sesión exitoso', false);
        // Aquí puedes navegar a la pantalla principal
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
                    'Login to your Account',
                    style: TextStyle(fontSize: 23, color: Colors.orange),
                  ),
                  const SizedBox(height: 50),
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
                    labelText: "Enter Your Password",
                    prefixIcon: Icons.password_outlined,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _isLoading ? null : _handleLogin,
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
                                "Login",
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Need an account?"),
                        SizedBox(width: 10),
                        Text(
                          "Register Now",
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
