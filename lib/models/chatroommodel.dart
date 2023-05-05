class ChatModel {
  String? chatroomid;
  String? practispants;

  ChatModel({this.chatroomid, this.practispants});
  ChatModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    practispants = map["practispants"];

  }
  //toMap is function to upper object convert data into map
  Map <String,dynamic>toMap(){
    return {
     "chatroomid":chatroomid,
     "practispants":practispants,


    };
  }
}
