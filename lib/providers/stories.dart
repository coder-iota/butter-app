import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/story.dart';

class Stories with ChangeNotifier {
  final latestStoriesUri =
      "https://hacker-news.firebaseio.com/v0/topstories.json";

  List<int> _stories = [];

  List<int> get stories {
    return [..._stories];
  }

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

  Future<Story> getStoryById(int id) async {
    final storyByIdUri = "https://hacker-news.firebaseio.com/v0/item/$id.json";

    final response = await http.get(Uri.parse(storyByIdUri));

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> storyJson = jsonDecode(response.body);

        return Story.fromJson(storyJson);
      } catch (e) {
        throw Exception("Error Parsing JSON for Story $id.");
      }
    } else {
      throw Exception("Error fetching Data for Story $id.");
    }
  }
}
