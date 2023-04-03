import 'package:flutter/material.dart';

class ItemPrice extends StatelessWidget {
  final double price;
  final int discount;
  final double pricePerKg;

  const ItemPrice({
    super.key,
    required this.price,
    required this.discount,
    required this.pricePerKg,
  });

  String getDiscountedPrice(double price, int discount) {
    return (price - (price * discount / 100)).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '€${getDiscountedPrice(price, discount)}',
          style: TextStyle(
            fontSize: 45,
            color: Colors.red[400],
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            Text(
              '€$price',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black54,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              '$pricePerKg€/kg',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        )
      ],
    );
  }
}
