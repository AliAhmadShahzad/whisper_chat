class BlockUser{
  BlockUser({
    required this.block,


  });
  late  bool block;

  BlockUser.fromJson(Map<String,dynamic> json){
    block  = json['block'] ?? false;

  }

  Map<String, dynamic> toJson(){
    final data = <String,dynamic> {};

    data['block'] = block;

    return data;
  }

}