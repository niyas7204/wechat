class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  DateTime? createdOn;
  bool? seen;
  MessageModel(
      {this.messageid, this.sender, this.text, this.createdOn, this.seen});
  MessageModel.frommap(Map<String, dynamic> map) {
    messageid = map['messageid'];
    sender = map['sender'];
    text = map['text'];
    createdOn = map['createdOn'].toDate();
    seen = map['seen'];
  }
  Map<String, dynamic> tomap() {
    return {
      'messageid': messageid,
      'sender': sender,
      'text': text,
      'createdOn': createdOn,
      'seen': seen
    };
  }
}
