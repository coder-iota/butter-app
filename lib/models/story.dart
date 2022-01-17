class Story{
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

  Map<String, Object> toDBValue(){
    return {
      'id': id,
      'title' : title,
      'by' : by,
      'time' : time.toIso8601String(),
      'url' : url
    };
  }
 
  factory Story.fromJson(Map<String, dynamic> storyJson){
    return Story(
      id: storyJson["id"],
      by: storyJson["by"],
      time: DateTime.fromMillisecondsSinceEpoch(storyJson["time"]*1000),
      title: storyJson["title"],
      url: storyJson["url"]??storyJson["text"]??"https://www.butter.us/",
    );
  }

  factory Story.fromDbValues(Map<String, dynamic> values){
    return Story(
      id: values["id"],
      by: values["by"],
      time: DateTime.parse(values["time"]),
      title: values["title"],
      url: values["url"]
    ); 
  }

}