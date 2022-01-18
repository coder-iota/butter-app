// Model class to represent the Story entity recieved from the database.

class Story {
  // Fields id, by, time, title and URL are absolute necessities for the application and therefore are required.
  // Other fields not stored in current database implementation but left optional, if required.
  final int id;
  final String by;
  final DateTime time;
  final List<int>? kids;
  final int? descendants;
  final int? score;
  final String title;
  final String url;
  bool deleted = false;
  bool dead = false;

  // Parameterized constructor.
  Story({
    required this.id,
    required this.by,
    required this.time,
    this.kids,
    this.descendants,
    this.score,
    required this.title,
    required this.url,
  });

  // Converts the object to Map used directly for database insert query.
  Map<String, Object> toDBValue() {
    return {
      'id': id,
      'title': title,
      'by': by,
      'time': time
          .toIso8601String(), // Because time is stored as string in the database.
      'url': url
    };
  }

  // Creating the object from JSON recieved through the API call.
  // Optional fields omitted due to reason stated above.
  factory Story.fromJson(Map<String, dynamic> storyJson) {
    return Story(
      id: storyJson["id"],
      by: storyJson["by"],
      time: DateTime.fromMillisecondsSinceEpoch(storyJson["time"] * 1000),
      title: storyJson["title"],
      url: storyJson["url"] ??
          storyJson["text"] ??
          "https://www.thebutterapp.com/", // Due to inconsistent data recieved from the API on some calls.
    );
  }

  // Creating object from database values for favorites.
  factory Story.fromDbValues(Map<String, dynamic> values) {
    return Story(
        id: values["id"],
        by: values["by"],
        time: DateTime.parse(values["time"]),
        title: values["title"],
        url: values["url"]);
  }
}
