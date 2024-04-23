import 'package:ecom_app/model/product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.products, 
  });
  final Product? products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              products!.image,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height / 8,
              width: MediaQuery.of(context).size.height / 8,
            ),
            const SizedBox(height: 10),
            Text(
              products!.title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            Text(products!.price.toString()),
          ],
        ),
      ),
    );
  }
}
