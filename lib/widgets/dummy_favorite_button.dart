import 'package:flutter/material.dart';
import 'package:katro_v2/common/styles.dart';

class DummyFavoriteButton extends StatefulWidget {
  const DummyFavoriteButton({Key? key}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State {

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
      },
      icon: isFavorite
          ? const Icon(Icons.favorite, color: primaryColor)
          : const Icon(Icons.favorite_border, color: Colors.white),
    );
  }
}
