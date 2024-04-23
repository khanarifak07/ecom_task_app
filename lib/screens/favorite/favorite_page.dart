import 'package:ecom_app/model/product_model.dart';
import 'package:ecom_app/utils/helper.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  final List<Product> favoriteProducts;

  const FavoritePage({
    super.key,
    required this.favoriteProducts,
  });

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: widget.favoriteProducts.isNotEmpty
          ? ListView.builder(
              itemCount: widget.favoriteProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      title: Row(
                        children: [
                          Image.network(
                            widget.favoriteProducts[index].image,
                            fit: BoxFit.contain,
                            height: 70,
                            width: 70,
                          ),
                          Expanded(
                            child: Text(
                              widget.favoriteProducts[index].title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                widget.favoriteProducts.removeAt(index);
                                setState(() {});
                                Helper.showSnackBar(context,
                                    "Removed from favorites", Colors.red);
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Colors.black.withOpacity(.5),
                              ))
                        ],
                      ),
                      // You can display other details of the product here
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No favorite products.'),
            ),
    );
  }
}
