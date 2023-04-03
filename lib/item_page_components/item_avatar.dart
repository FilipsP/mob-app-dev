import 'package:flutter/material.dart';

class ItemAvatar extends StatelessWidget {
  final int discount;
  final String image;

  const ItemAvatar({super.key, required this.discount, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 78,
          backgroundColor: Colors.yellowAccent,
          child: CircleAvatar(
            radius: 75,
            backgroundImage: AssetImage(image),
            backgroundColor: Colors.white,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0.0, 2.0),
                ),
                BoxShadow(
                  color: Colors.yellowAccent,
                  offset: Offset(0.0, 2.0),
                  spreadRadius: 1.0,
                  blurRadius: 3.0,
                )
              ],
            ),
            child: Text(
              '-$discount%',
              style: TextStyle(
                fontSize: 40,
                color: Colors.red[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
