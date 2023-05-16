// To parse this JSON data, do
//
//     final mesaageModel = mesaageModelFromJson(jsonString);

import 'dart:convert';

MesaageModel mesaageModelFromJson(String str) =>
    MesaageModel.fromJson(json.decode(str));

String mesaageModelToJson(MesaageModel data) => json.encode(data.toJson());

class MesaageModel {
  MesaageModel({
    required this.formId,
    required this.msg,
    required this.read,
    required this.told,
    required this.sent,
    required this.type,
    required this.pdfTxt
  });

  late final String formId;
  late final String msg;
  late final String read;
  late final String told;
  late final String sent;
  late final Type type;
  late final String pdfTxt;

  factory MesaageModel.fromJson(Map<String, dynamic> json) => MesaageModel(
        formId: json["formId"].toString(),
        msg: json["msg"].toString(),
        read: json["read"].toString(),
        told: json["told"].toString(),
        type:
            detectType(json["type"].toString()),
        sent: json["sent"].toString(),
        pdfTxt: json["pdfTxt"].toString(),
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["formId"] = formId;
    data["msg"] = msg;
    data["read"] = read;
    data["told"] = told;
    data["type"] = type.name;
    data["sent"] = sent;
    data["pdfTxt"]=pdfTxt;
    return data;
  }
}
Type detectType(String value){
switch(value){
  case 'text':
  return Type.text;
   
  case 'image':
   
  return Type.image;
   case 'pdf':
  return Type.pdf;
  default :
  return Type.none;
}

}

enum Type { text, image,pdf,none 
}
