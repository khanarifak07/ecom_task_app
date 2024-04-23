import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecom_app/screens/auth/register_page.dart';
import 'package:ecom_app/screens/homepage/homepage.dart';
import 'package:ecom_app/utils/config.dart';
import 'package:ecom_app/utils/helper.dart';
import 'package:ecom_app/widgets/ktextfield.dart';
import 'package:ecom_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _HomePageState();
}

class _HomePageState extends State<LoginPage> {
  bool isLoading = false;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  Future<void> saveTokenToSF(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    } catch (e) {
      log("Error while saving token");
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      Dio dio = Dio();
      //
      var data = {
        "email": email,
        "password": password,
      };
      //make dio post request
      Response response = await dio.post(loginURI, data: data);
      //handle the response
      if (response.statusCode == 201) {
        final String? token = response.data['access_token'];
        if (token != null) {
          await saveTokenToSF(token);
        }
        Helper.nextScreenPushAndRemove(context, const HomePage());
      } else {
        log("error while login ${response.statusCode}");
      }
    } catch (e) {
      log("Error while login $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_grocery_store_sharp,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome back , you've been missed!",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),
              KTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailCtrl,
              ),
              const SizedBox(height: 20),
              KTextField(
                hintText: "Password",
                obscureText: true,
                controller: passCtrl,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                      text: "Login",
                      onTap: () async {
                        if (emailCtrl.text.isEmpty && passCtrl.text.isEmpty) {
                          Helper.showSnackBar(context,
                              "Please enter email and password", Colors.red);
                        } else {
                          loginUser(
                            email: emailCtrl.text,
                            password: passCtrl.text,
                          );
                        }
                      },
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  GestureDetector(
                    onTap: () {
                      Helper.nextScreen(context, const RegisterPage());
                    },
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
