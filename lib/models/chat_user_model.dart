class ChatUserModel{
  ChatUserModel({
    required this.name,
    required this.lastMessage,
    required this.image,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.block,


});
  late  String image;
  late  String name;
  late  String lastMessage;
  late  String createdAt;
  late  bool isOnline;
  late  bool block;
  late  String id;
  late  String lastActive;
  late  String email;
  late  String pushToken;

  ChatUserModel.fromJson(Map<String,dynamic> json){
    image  = json['image'] ?? '';
    lastMessage = json['last_message'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    block = json['block'] ?? false;
  }

    Map<String, dynamic> toJson(){
    final data = <String,dynamic> {};

    data['image'] = image;
    data['last_message'] = lastMessage;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data["id"] = id;
    data["last_active"] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['block'] = block;

    return data;
  }

}