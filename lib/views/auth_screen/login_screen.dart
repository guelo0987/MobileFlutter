

import 'package:dartproyect/views/auth_screen/register_screen.dart';
import 'package:dartproyect/views/components/FormField.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(

          child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text('Login to your Account ', style: TextStyle(
                fontSize: 23,
                color: Colors.orange
              )),
                SizedBox(
                  height: 50,
                ),
                MyTextFormField(
                    controller: emailController,
                    keyBoardType: TextInputType.emailAddress,
                    obscureText: true,
                    hintText: "user@example.com",
                    labelText: "Email",
                    prefixIcon: Icons.email_outlined
                ),
                
                MyTextFormField(controller: passwordController,
                    keyBoardType: TextInputType.visiblePassword,
                    obscureText: true,
                    hintText: "Password",
                    labelText: "Enter Your Password",
                    prefixIcon: Icons.password_outlined
                ),

                InkWell(onTap: ()=>{
                  //Login Button
                },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        // Aquí va la lógica de login
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell( onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()
                  ),
                  );
                },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Need an account?"),
                      SizedBox(width: 10),
                      Text("Register Now", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange
                      ),)
                    ],
                                ),
                ),
            ],
            ),
          )
        ),
      ),
    );
  }
}
