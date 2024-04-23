import 'package:ecom_app/screens/favorite/favorite_page.dart';
import 'package:ecom_app/model/product_model.dart';
import 'package:ecom_app/utils/helper.dart';
import 'package:ecom_app/widgets/star_ratings.dart';
import 'package:flutter/material.dart';

List<Product> favoriteProducts = [];

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Product Details Page"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                Helper.nextScreen(
                    context, FavoritePage(favoriteProducts: favoriteProducts));
              },
              icon: const Icon(Icons.favorite_outline),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  product.rating.rate.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StarRating(rating: product.rating.rate),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * .4,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                width: double.maxFinite,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$\t${product.price.toString()}',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                product.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    favoriteProducts.add(product);
                    Helper.showSnackBar(
                        context, "Added to favorite", Colors.green);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        color: const Color(0xffff406c),
                        borderRadius: BorderRadius.circular(10)),
                    height: 60,
                    width: 250,
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            "ADD TO FAVORITE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
