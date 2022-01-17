import '../models/story.dart';
import '../providers/stories.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Favorite stories Screen 
class FavoriteStoriesScreen extends StatelessWidget {
  FavoriteStoriesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Favorite Stories"),
      ),
      
      drawer: CustomDrawer(),
      
      body: FutureBuilder(
        // Awaits the list of currently stored favorite stories.
        future: Provider.of<Stories>(context).getFavoriteStories(),

        builder: (context, AsyncSnapshot<List<Story>> favStoriesSnap) {
          
          // Displays progress indicator till the future is resolved.
          if (favStoriesSnap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Storing the dynamic stories list.
          final stories = favStoriesSnap.data;

          // Returns list of favorite stories similar to top stories screen
          return stories?.length == 0
              ? const Center(
                  child: Text("No Favorites Added"),
                )
              : ListView.builder(
                  itemCount: stories?.length,
                  itemBuilder: (context, inx) {
                    final story = stories![inx];
                    return ListTile(
                        title: Text(story.title),
                        subtitle: Text(story.time.toString()),
                        trailing: FavoriteButton(story: story, isFav: true));
                  },
                );
        },
      ),
    );
  }
}
