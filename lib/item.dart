import 'package:flutter/material.dart';
import 'package:mob_app_dev/item_page_components/item_options.dart';
import 'package:mob_app_dev/item_page_components/item_price.dart';
import 'item_page_components/item_avatar.dart';

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.shop,
    required this.title,
    required this.image,
    required this.description,
    required this.price,
    required this.pricePerKg,
    required this.discount,
  });

  final String shop;
  final String title;
  final String image;
  final String description;
  final double price;
  final double pricePerKg;
  final int discount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Discount Found!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black12,
              width: 2.0,
            ),
            color: Colors.white,
          ),
          width: 400,
          child: Column(
            children: [
              const SizedBox(height: 20),
              ItemAvatar(
                discount: discount,
                image: image,
              ),
              const SizedBox(height: 20),
              ItemPrice(
                  price: price, discount: discount, pricePerKg: pricePerKg),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black54,
                ),
              ),
              const Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              SizedBox(
                height: 180,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.store, size: 35),
                    const SizedBox(width: 10),
                    Text(
                      shop,
                      style: const TextStyle(
                        fontSize: 35,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black12,
                thickness: 2,
              ),
              const SizedBox(height: 20),
              const ItemOptions(),
              const SizedBox(height: 20),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: const Border(
                    bottom: BorderSide(
                      color: Colors.black12,
                      width: 2.0, // set the width of the border
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
