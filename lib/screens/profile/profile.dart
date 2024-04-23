import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecom_app/model/user_model.dart';
import 'package:ecom_app/screens/auth/login_page.dart';
import 'package:ecom_app/utils/config.dart';
import 'package:ecom_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isDataLoaded = false;
  UserModel? model;
  bool fieldEditing = false;
  bool isLoading = false;

  late TextEditingController nameCtrl =
      TextEditingController(text: model!.name);
  late TextEditingController emailCtrl =
      TextEditingController(text: model!.email);

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user_data");
    if (user != null) {
      model = UserModel.fromJson(user);
    }
    setState(() {
      isDataLoaded = true;
    });
  }

  File? avatar;
  Future<void> pickAvatar() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        avatar = File(pickedFile.path);
      });
    }
  }

  Future<void> savedUpdatedUserData(UserModel model) async {
    var pref = await SharedPreferences.getInstance();
    pref.setString('user_data', model.toJson());
    print(
        "Update user data saved successfully in shared preference ${model.toJson()}");
  }

  Future<void> updateUser({
    required String name,
    required String email,
  }) async {
    try {
      setState(() {
        isLoading = false;
      });
      //dio instance
      Dio dio = Dio();
      //data
      var data = {
        'name': name,
        'email': email,
        'avatar': "https://picsum.photos/800"
      };
      //make dio put request
      Response response =
          await dio.put(updateUserURI(model!.id.toString()), data: data);

      //handle response
      if (response.statusCode == 200) {
        log('User Updated: ${response.data}');
        //now I have saved user data in shared preference I need to remove that data and again saved the updated user data
        var prefs = await SharedPreferences.getInstance();
        prefs.remove('user');
        //now save the updated user data
        final updatedUser = UserModel.fromMap(response.data);
        savedUpdatedUserData(updatedUser);
      } else {
        log("Error while updating user ${response.statusCode}");
      }
    } catch (e) {
      log("Error while updating user $e");
    }
  }

  Future<void> logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user_data');
    Helper.nextScreenPushAndRemove(context, const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('My profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                logout();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: model != null
          ? Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      pickAvatar();
                    },
                    child: avatar != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                MemoryImage(avatar!.readAsBytesSync()))
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              model!.avatar,
                            ),
                          ),
                  ),
                  const Text("Avatar"),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          fieldEditing = !fieldEditing;
                        });
                      },
                      child: fieldEditing
                          ? const Icon(Icons.clear)
                          : const Icon(Icons.edit),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    enabled: fieldEditing,
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    enabled: fieldEditing,
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  fieldEditing
                      ? MaterialButton(
                          minWidth: 200,
                          height: 50,
                          color: Theme.of(context).colorScheme.tertiary,
                          onPressed: isLoading
                              ? null
                              : () async {
                                  updateUser(
                                      name: nameCtrl.text,
                                      email: emailCtrl.text);
                                  setState(() {
                                    fieldEditing = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Profile details updated successfully")));
                                },
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : const Text("Update"),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            )
          : isDataLoaded
              ? const Center(
                  child: Text("Something went wrong while fetching user data"))
              : const Center(
                  child: CircularProgressIndicator(),
                ),
    );
  }
}
