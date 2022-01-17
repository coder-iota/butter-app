import '../models/story.dart';
import '../providers/stories.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        future: Provider.of<Stories>(context).getFavoriteStories(),
        builder: (context, AsyncSnapshot<List<Story>> favStoriesSnap) {
          if (favStoriesSnap.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final stories = favStoriesSnap.data;

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
