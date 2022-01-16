import '../providers/stories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("List of Stories"),
        ),
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
                        title: Text("Loading..."),
                        subtitle: Text("Loading..."),
                        trailing: IconButton(
                          onPressed: null,
                          icon: Icon(Icons.favorite),
                        ),
                      );
                    }

                    final story = storySnap.data;
                    final tempTitle = story?.title ?? "Error Fetching Title";
                    final tempDate = story?.time == null
                        ? "Error Fetching Date"
                        : story!.time.toString();
                    return ListTile(
                      title: Text(tempTitle),
                      subtitle: Text(tempDate),
                      trailing: const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.favorite),
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
