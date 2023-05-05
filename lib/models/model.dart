class UserModel{
  String ?uid;
  String ?fullName;
  String ?email;
  String ?profile;
  UserModel({this.uid,this.fullName,this.email,this.profile});
  UserModel.fromMap(Map<String,dynamic>map){
    uid=map["uid"];
    fullName=map["fullName"];
    email =map["email"];
    profile=map["profile"];
  }
  Map <String,dynamic>toMap(){
    return {
      "uid":uid,
      "fullName":fullName,
      "email":email,
      "profile":profile,

    };
  }

}