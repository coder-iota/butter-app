import 'package:intl/intl.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/favorite_button.dart';
import '../providers/stories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// This is the home screen of the application.
class StoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Top Stories"),
        ),
        drawer: CustomDrawer(),
        body: FutureBuilder(
          // Awaits the API fetch of the latest top story IDs.
          future: Provider.of<Stories>(context).fetchLatestStories(),

          builder: (context, AsyncSnapshot<List<int>> snap) {
            // Displays progress indicator till the future is resolved.
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Stores the list of latest story IDs.
            final stories = snap.data;

            return ListView.builder(
              itemCount: stories?.length,
              itemBuilder: (context, inx) {
                return FutureBuilder(
                  // Awaits the API call to fetch a story object based on the ID.
                  future:
                      Provider.of<Stories>(context).getStoryById(stories![inx]),
                  builder: (context, AsyncSnapshot<dynamic> storySnap) {
                    // Displays progress indicator till the future is resolved.
                    if (storySnap.connectionState != ConnectionState.done) {
                      return const ListTile(
                        title: Text(""),
                        subtitle: Text(""),
                      );
                    }

                    // Stores the story object for current story id.
                    final story = storySnap.data;

                    // Variables to store the data with sound null safety.
                    final listTileTitle =
                        story?.title ?? "Error Fetching Title";
                    final tempDate = story?.time == null ? null : story!.time;
                    // Formatting the date using intl package.
                    final dateString = tempDate == null
                        ? "Error loading date"
                        : DateFormat.yMd().add_jm().format(tempDate);

                    return ListTile(
                      isThreeLine: true,
                      title: Text(listTileTitle),
                      subtitle: Text(
                          "Posted On: $dateString\n" + "\nBy: ${story.by}"),
                      // Disabling the fav button if the story is not appropriate.
                      trailing: FavoriteButton(
                        story: story,
                        isFav: false,
                        disabled: listTileTitle == "Story Unavailable",
                      ),
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
