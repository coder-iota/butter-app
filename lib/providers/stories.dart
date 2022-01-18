import 'dart:convert';

import '../helpers/dbhelper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/story.dart';

class Stories with ChangeNotifier {
  // URI to fetch latest top stories.
  final latestStoriesUri =
      "https://hacker-news.firebaseio.com/v0/topstories.json";

  // Stores the IDs of latest top stories.
  List<int> _stories = [];

  // Getter for stories.
  List<int> get stories {
    return [..._stories];
  }

  // Maked API call to fetch and set the latest stories from the API.
  Future<List<int>> fetchLatestStories() async {
    final response = await http.get(Uri.parse(latestStoriesUri));
    if (response.statusCode == 200) {
      try {
        _stories = [];
        _stories.addAll(List<int>.from(json.decode(response.body)));
        return Future.value([..._stories]);
      } catch (e) {
        throw Exception("Error Parsing JSON.");
      }
    } else {
      throw Exception("Error fetching Data.");
    }
  }

  // Gets the entire JSON for a story based on the object ID.
  Future<Story> getStoryById(int id) async {
    final storyByIdUri = "https://hacker-news.firebaseio.com/v0/item/$id.json";
    final response = await http.get(Uri.parse(storyByIdUri));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> storyJson = jsonDecode(response.body);

        // Due to Inconsistent data recieved from the API. Displayed with disabled Fav button.
        if (storyJson["type"] != "story") {
          return Story(
              id: id,
              by: "Invalid Story",
              time: DateTime.now(),
              title: "Story Unavailable",
              url: "https://www.butter.us/");
        }

        return Story.fromJson(storyJson);
      } catch (e) {
        throw Exception("Error Parsing JSON for Story $id.");
      }
    } else {
      throw Exception("Error fetching Data for Story $id.");
    }
  }

  // Adds a story to Favorites.
  Future<int> addStoryToFavs(Story story) async {
    final storyValues = story.toDBValue();
    return await DBHelper.addFavorite(storyValues);
  }

  // Removes a favorite story.
  Future<int> removeStoryFromFavs(Story story) async {
    final storyId = story.id;
    return await DBHelper.removeFromFavorite(storyId);
  }

  // Fetches and creates the currently stored favorite stories list.
  Future<List<Story>> getFavoriteStories() async {
    final favStoriesValues = await DBHelper.getAllFavorites();

    // Mapping the values received to real objects.
    List<Story> favoriteStories = [];
    for (var storyValues in favStoriesValues) {
      favoriteStories.add(Story.fromDbValues(storyValues));
    }
    return favoriteStories;
  }

  // To get the favorite status for a story on top stories screen.
  Future<bool> hasFavoriteStoryWithId(int id) async {
    final queryResult = await DBHelper.getAllFavIds();

    // Mapping the values received to integers.
    List<int> favIds = [];
    for (var resultSet in queryResult) {
      favIds.add(int.parse(resultSet["id"].toString()));
    }
    if (favIds.contains(id)) {
      return true;
    } else {
      return false;
    }
  }
}
