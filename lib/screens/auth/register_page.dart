import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecom_app/model/user_model.dart';
import 'package:ecom_app/screens/auth/login_page.dart';
import 'package:ecom_app/utils/config.dart';
import 'package:ecom_app/utils/helper.dart';
import 'package:ecom_app/widgets/ktextfield.dart';
import 'package:ecom_app/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  bool isLoading = false;

  //dispose the controllers
  @override
  void dispose() {
    super.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
  }

  Future<void> saveUserDatatoSF(UserModel userModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_data", userModel.toJson());
      print("User data saved successfully ${userModel.toJson()}");
    } catch (e) {
      log("Error while saving user data");
    }
  }

  Future<void> registerUser({
    required UserModel userModel,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });
      //dio instace
      Dio dio = Dio();
      //data
      var data = userModel.toMap();
      //dio post requesta
      Response response = await dio.post(registerURI, data: data);
      //handle the response
      if (response.statusCode == 201) {
        log("User registered successfully ${response.data}");
        //save user data to shared pref
        final user = UserModel.fromMap(response.data);
        await saveUserDatatoSF(user);
        Helper.nextScreenPushAndRemove(context, const LoginPage());
        Helper.showSnackBar(
            context, "User Registered Successfully", Colors.green.shade300);
      } else {
        log("User registeration failed ${response.statusCode}");
      }
    } catch (e) {
      log("Something went wrong while registering user $e");
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
                hintText: "Name",
                obscureText: false,
                controller: nameCtrl,
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
                      text: "Register",
                      onTap: () async {
                        if (nameCtrl.text.isEmpty &&
                            emailCtrl.text.isEmpty &&
                            passCtrl.text.isEmpty) {
                          Helper.showSnackBar(
                              context, "Please fill the details", Colors.red);
                        } else if (!Helper.isValidEmail(emailCtrl.text)) {
                          Helper.showSnackBar(
                              context, "Please fill valid email", Colors.red);
                        } else if (passCtrl.text.length < 6) {
                          Helper.showSnackBar(
                            context,
                            "Password must be at least 6 characters",
                            Colors.red,
                          );
                        } else {
                          registerUser(
                              userModel: UserModel(
                            name: nameCtrl.text,
                            email: emailCtrl.text,
                            password: passCtrl.text,
                            avatar: "https://picsum.photos/800",
                          ));
                        }
                      },
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  GestureDetector(
                    onTap: () {
                      Helper.nextScreen(context, const LoginPage());
                    },
                    child: Text(
                      "Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
