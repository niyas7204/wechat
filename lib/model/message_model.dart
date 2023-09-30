enum MessageType{text,image}
class MessageModel {
  String? messageid;
  String? sender;
  String? message;
  MessageType? messageType;
  DateTime? createdOn;
  bool? seen;
  MessageModel(
      {this.messageid, this.sender, this.message,this.messageType, this.createdOn, this.seen});
  MessageModel.frommap(Map<String, dynamic> map) {
    messageid = map['messageid'];
    sender = map['sender'];
    message = map['text'];
    messageType=map['messageType'];
    createdOn = map['createdOn'].toDate();
    seen = map['seen'];
  }
  Map<String, dynamic> tomap() {
    return {
      'messageid': messageid,
      'sender': sender,
      'text': message,
      'messageType':messageType,
      'createdOn': createdOn,
      'seen': seen
    };
  }
}
