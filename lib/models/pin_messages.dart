import 'package:cloud_firestore/cloud_firestore.dart';

class PinMessagesModels{

  PinMessagesModels({
    required this.message,
    required this.time,
    required this.id,

  });
  late  String message;
  late  String time;
  late  String id;

  factory PinMessagesModels.fromJson(Map<String,dynamic> json){
    return PinMessagesModels(
      message: json['message']??'', time: json['time']??'',id: json['id']??''
    );

  }

  Map<String, dynamic> toJson(){
    final data = <String,dynamic> {};
    data['message'] = message;
    data['time'] = time;
    data['id'] = id;

    return data;
  }

}