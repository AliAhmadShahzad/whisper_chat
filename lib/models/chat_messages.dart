class MessagesModel {
  MessagesModel({
    required this.docid,
    required this.toid,
    required this.fromid,
    required this.msg,
    required this.read,
    required this.sent,
    required this.type,
  });

  late final String docid;
  late final String toid;
  late final String fromid;
  late final String msg;
  late final String sent;
  late final String read;
  late final Type type;

  MessagesModel.fromJson(Map<String, dynamic> json) {
    docid = json['docid'].toString();
    toid = json['toid'].toString();
    fromid = json['fromid'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    msg = json['msg'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['docid'] = docid;
    data['toid'] = toid;
    data['fromid'] = fromid;
    data['msg'] = msg;
    data['sent'] = sent;
    data['read'] = read;
    data['type'] = type.name;  // Serialize enum to string
    return data;
  }
}

enum Type { text, image }
