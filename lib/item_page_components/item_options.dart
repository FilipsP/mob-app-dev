import 'package:flutter/material.dart';
import 'package:mob_app_dev/item_page_components/item_button.dart';

class ItemOptions extends StatelessWidget {
  const ItemOptions({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ItemButton(
            text: "Previous", onPressed: () => print("Works"), size: 100),
        ItemButton(text: "Store", onPressed: () => print("Works"), size: 100),
        ItemButton(text: "Next", onPressed: () => print("Works"), size: 100),
      ],
    );
  }
}
