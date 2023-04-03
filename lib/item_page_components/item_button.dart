import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  const ItemButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.size});

  final String text;
  final VoidCallback onPressed;
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size / 2,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        child: Text(text,
            style: TextStyle(
              fontSize: size / 10,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
