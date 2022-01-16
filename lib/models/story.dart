class Story{
  final int id;
  final String type;
  final String by;
  final DateTime time;
  final List<int>? kids;
  final int descendants;
  final int score;
  final String title;
  final String url;
  bool deleted = false;
  bool dead = false;

  Story({
    required this.id,
    required this.type,
    required this.by,
    required this.time,
    this.kids,
    required this.descendants,
    required this.score,
    required this.title,
    required this.url,
  });

  factory Story.fromJson(Map<String, dynamic> storyJson){
    return Story(
      id: storyJson["id"],
      type: storyJson["type"],
      by: storyJson["by"],
      descendants: storyJson["descendants"],
      score: storyJson["score"],
      time: DateTime.fromMillisecondsSinceEpoch(storyJson["time"]*1000),
      title: storyJson["title"],
      url: storyJson["url"]
    );
  }

}