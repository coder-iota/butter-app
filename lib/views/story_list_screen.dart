import 'package:intl/intl.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorite_button.dart';
import '../providers/stories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Top Stories"),
        ),
        drawer: CustomDrawer(),
        body: FutureBuilder(
          future: Provider.of<Stories>(context).fetchLatestStories(),
          builder: (context, AsyncSnapshot<List<int>> snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final stories = snap.data;

            return ListView.builder(
              itemCount: stories?.length,
              itemBuilder: (context, inx) {
                return FutureBuilder(
                  future:
                      Provider.of<Stories>(context).getStoryById(stories![inx]),
                  builder: (context, AsyncSnapshot<dynamic> storySnap) {
                    if (storySnap.connectionState != ConnectionState.done) {
                      return const ListTile(
                        title: Text(""),
                        subtitle: Text(""),
                      );
                    }

                    final story = storySnap.data;
                    final tempTitle = story?.title ?? "Error Fetching Title";
                    
                    final tempDate = story?.time == null
                        ? null
                        : story!.time;
                    final dateString = tempDate==null?"Error loading date":DateFormat.yMd().add_jm().format(tempDate);

                    return ListTile(
                      isThreeLine: true,
                      title: Text(tempTitle),
                      subtitle: Text(dateString + "\n" + story.by),
                      trailing: FavoriteButton(story: story, isFav: false, disabled: tempTitle=="Story Unavailable",),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
