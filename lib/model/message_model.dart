class MessageModel {
  String? sender;
  String? text;
  DateTime? createdOn;
  bool? seen;
  MessageModel({this.sender, this.text, this.createdOn, this.seen});
  MessageModel.frommap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    createdOn = map['text'];
    seen = map['seen'];
  }
  Map<String, dynamic> tomap() {
    return {
      'sender': sender,
      'text': text,
      'createdOn': createdOn,
      'seen': seen
    };
  }
}
