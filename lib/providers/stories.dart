import 'dart:convert';

import '../helpers/dbhelper.dart';
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

  Future<bool> hasFavoriteStoryWithId(int id) async {
    final queryResult = await DBHelper.getAllFavIds();
    List<int> favIds = [];
    for(var resultSet in queryResult){
      favIds.add(int.parse(resultSet["id"].toString()));
    }
        if(favIds.contains(id)){
          return true;
        }
        else{
          return false;
        }
  }

  Future<Story> getStoryById(int id) async {
    final storyByIdUri = "https://hacker-news.firebaseio.com/v0/item/$id.json";
    final response = await http.get(Uri.parse(storyByIdUri));
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> storyJson = jsonDecode(response.body);
        if(storyJson["type"] != "story"){
          return Story(id: id, by: "Invalid Story", time: DateTime.now(), title: "Story Unavailable", url: "https://www.butter.us/");
        }

        return Story.fromJson(storyJson);
      } catch (e) {
        throw Exception("Error Parsing JSON for Story $id.");
      }
    } else {
      throw Exception("Error fetching Data for Story $id.");
    }
  }


  Future<int> addStoryToFavs(Story story) async{
    final storyValues = story.toDBValue();
    return await DBHelper.addFavorite(storyValues);
  }

  Future<int> removeStoryFromFavs(Story story) async{
    final storyId = story.id;
    return await DBHelper.removeFromFavorite(storyId);
  }

  Future<List<Story>> getFavoriteStories() async{
    final favStoriesValues = await DBHelper.getAllFavorites();
    List<Story> favoriteStories = [];
    for(var storyValues in favStoriesValues){
      favoriteStories.add(Story.fromDbValues(storyValues));
    }
    return favoriteStories;
  }
}
