import 'package:cloud_firestore/cloud_firestore.dart';

class WordEffectModels{

  WordEffectModels({
    required this.word,
    required this.effect,
    required this.id,

  });
  late  String word;
  late String effect;
  late String id;

  factory WordEffectModels.fromJson(Map<String,dynamic> json){
    return WordEffectModels(
      word: json['word']??'', effect: json['effect']??'', id: json['id'],
    );

  }

  Map<String, dynamic> toJson(){
    final data = <String,dynamic> {};

    data['word'] = word;
    data['effect'] = effect;
    data['id'] = id;

    return data;
  }

}