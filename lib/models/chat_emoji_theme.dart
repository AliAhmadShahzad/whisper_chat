class ChatEmojiTheme{
  ChatEmojiTheme({
    required this.emoji,
    required this.theme,

  });
  late  String emoji;
  late  String theme;

  ChatEmojiTheme.fromJson(Map<String,dynamic> json){
    emoji  = json['emoji'] ?? '';
    theme = json['theme'] ?? '';

  }

  Map<String, dynamic> toJson(){
    final data = <String,dynamic> {};

    data['emoji'] = emoji;
    data['theme'] = theme;


    return data;
  }

}