import 'package:cloud_firestore/cloud_firestore.dart';

class PinMessagesModels{

  PinMessagesModels({
    required this.message,
    required this.time,

  });
  late  String message;
  late  String time;

  factory PinMessagesModels.fromJson(Map<String,dynamic> json){
    return PinMessagesModels(
      message: json['message']??'', time: json['time']??'',
    );

  }

  Map<String, dynamic> toJson(){
    final data = <String,dynamic> {};
    data['message'] = message;
    data['time'] = time;

    return data;
  }

}