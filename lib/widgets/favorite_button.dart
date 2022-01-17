import 'package:butter_app/models/story.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  FavoriteButton({required this.story, required this.isFav, this.disabled=false});

  final Story story;
  bool isFav;
  final bool disabled;
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  
  void handleFavToggle(){
    setState(() {
      widget.isFav = !widget.isFav;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final favIcon = widget.isFav
        ? const Icon(Icons.favorite)
        : const Icon(Icons.favorite_border);
    return IconButton(
      icon: favIcon,
      onPressed: widget.disabled? null:handleFavToggle,
    );
  }
}
