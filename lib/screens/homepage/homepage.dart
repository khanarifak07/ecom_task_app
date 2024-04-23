import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ecom_app/screens/favorite/favorite_page.dart';
import 'package:ecom_app/model/product_model.dart';
import 'package:ecom_app/model/user_model.dart';
import 'package:ecom_app/screens/profile/profile.dart';
import 'package:ecom_app/screens/product/product_details_page.dart';
import 'package:ecom_app/utils/config.dart';
import 'package:ecom_app/utils/helper.dart';
import 'package:ecom_app/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product>? products;
  UserModel? userModel;

  Future<List<Product>?> getAllProducts() async {
    try {
      //dio instance
      Dio dio = Dio();
      //make dio get request
      Response response = await dio.get(getAllProductsURI);
      //handle the response
      if (response.statusCode == 200) {
        List<dynamic> productsDataList = response.data;
        List<Product>? productsData =
            productsDataList.map((e) => Product.fromMap(e)).toList();
        // setState(() {
        //   this.products = products;
        // });
        return productsData;
      } else {
        log('${response.statusCode}');
      }
    } catch (e) {
      log("Error while fetching all products: $e");
    }
    return null;
  }

  @override
  void initState() {
    getAllProducts().then((fetchedProducts) {
      setState(() {
        products = fetchedProducts;
      });
    });
    super.initState();
    getData();
  }

  UserModel? model;
  bool isDataLoaded = false;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.secondary,
      appBar: AppBar(
        backgroundColor: theme.secondary,
        title: const Text("All Products"),
        actions: [
          IconButton(
            onPressed: () async {
              Helper.nextScreen(
                  context,
                  FavoritePage(
                    favoriteProducts: favoriteProducts,
                  ));
            },
            icon: Icon(Icons.favorite_outline,
                size: 30, color: Colors.black.withOpacity(.5)),
          ),
          IconButton(
            onPressed: () async {
              Helper.nextScreen(context, const Profile());
            },
            icon: model != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(model!.avatar))
                : const CircleAvatar(),
          ),
        ],
      ),
      body: products != null
          ? GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: products!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: products![index],
                        ),
                      ),
                    );
                  },
                  child: ProductCard(
                    products: products![index],
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
