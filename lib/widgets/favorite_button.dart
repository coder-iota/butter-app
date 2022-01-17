import '../models/story.dart';
import '../providers/stories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Button to handle the favorite status of a story.
class FavoriteButton extends StatefulWidget {

  FavoriteButton({required this.story, required this.isFav, this.disabled = false});

  
  final Story story;  // Story the button is intended for.
  bool isFav; // Favorite status maintained in the state of the widget.
  final bool disabled;  // Is true if story is unavailable.

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {

  // Handles the tap of the favorite button, changes the fav status of story with realtime update in the database.
  void handleFavToggle() {
    if (!widget.isFav) {
      Provider.of<Stories>(context, listen: false).addStoryToFavs(widget.story);
    } else {
      Provider.of<Stories>(context, listen: false)
          .removeStoryFromFavs(widget.story);
    }
    setState(() {
      widget.isFav = !widget.isFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Awaits the database query to check if the story is already a favorite.
      future: Provider.of<Stories>(context).hasFavoriteStoryWithId(widget.story.id),
      
      builder: (context, AsyncSnapshot<bool> snap) {
        // Returns a disabled button while the future is unresolved. 
        if (snap.connectionState != ConnectionState.done) {
          return const IconButton(
              onPressed: null, icon: Icon(Icons.favorite_border));
        }
        // Returns disabled button if the story is unavailable.
        if(widget.disabled){
          return const IconButton(onPressed: null, icon: Icon(Icons.favorite_border));
        }

        // Stores the resolved value from the future.
        final isFavInDb = snap.data ?? false;

        // Updating the widget state with the resolved value.
        widget.isFav = isFavInDb;

        // Fills the fav icon if the story is in favorites.
        final favIcon = isFavInDb
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border);
        return IconButton(onPressed: handleFavToggle, icon: favIcon);
      },
    );
  }
}
