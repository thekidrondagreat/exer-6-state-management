import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/shoppingcart_provider.dart';
import '../model/item.dart';

class Checkout extends StatelessWidget {
  const Checkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getItems(context),
          computeCost(),
          const Divider(height: 4, color: Colors.black),
          ElevatedButton(
            onPressed: () {
              context.read<ShoppingCart>().checkout();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Payment Successful!"),
                  duration: Duration(seconds: 1, milliseconds: 100),
                ),
              );
              Navigator.pop(context); // Go back to cart
            },
            child: const Text("Pay Now!"),
          ),
        ],
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
        ? const Text("No items to show!")
        : Expanded(
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: const Icon(Icons.food_bank),
                        title: Text(products[index].name),
                        trailing: Text("\$${products[index].price.toStringAsFixed(2)}"),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget computeCost() {
    return Consumer<ShoppingCart>(builder: (context, cart, child) {
      return Text("Total: \$${cart.cartTotal.toStringAsFixed(2)}");
    });
  }
}
