import 'package:flutter/material.dart';
import '../model/item.dart';
import 'package:provider/provider.dart';
import '../provider/shoppingcart_provider.dart';

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          getItems(context),
          computeCost(),
          const Divider(height: 4, color: Colors.black),
          Flexible(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ShoppingCart>().removeAll();
                    },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (context.read<ShoppingCart>().cart.isNotEmpty) {
                        Navigator.pushNamed(context, "/checkout");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cart is empty!"),
                            duration: Duration(seconds: 1, milliseconds: 100),
                          ),
                        );
                      }
                    },
                    child: const Text("Checkout"),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            child: const Text("Go back to Product Catalog"),
            onPressed: () {
              Navigator.pushNamed(context, "/products");
            },
          ),
        ],
      ),
    );
  }

  Widget getItems(BuildContext context) {
    List<Item> products = context.watch<ShoppingCart>().cart;
    return products.isEmpty
        ? const Text("No items yet!")
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
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            String productName = products[index].name;
                            context.read<ShoppingCart>().removeItem(productName);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("$productName removed!"),
                              duration: const Duration(seconds: 1, milliseconds: 100),
                            ));
                          },
                        ),
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
