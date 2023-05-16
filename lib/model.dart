// To parse this JSON data, do
//
//     final chatuser = chatuserFromJson(jsonString);

import 'dart:convert';

Chatuser chatuserFromJson(String str) => Chatuser.fromJson(json.decode(str));

String chatuserToJson(Chatuser data) => json.encode(data.toJson());

class Chatuser {
  String image;
  String name;
  String about;
  String createdAt;
  String lastActive;
  bool isOnline;
  String id;
  String email;
  String pushToken;

  Chatuser({
    required this.image,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.email,
    required this.pushToken,
  });

  factory Chatuser.fromJson(Map<String, dynamic> json) => Chatuser(
        image: json["image"] ?? '',
        name: json["name"] ?? '',
        about: json["about"] ?? '',
        createdAt: json["created_at"] ?? '',
        lastActive: json["last_active"] ?? '',
        isOnline: json["is_online"],
        id: json["id"] ?? '',
        email: json["email"] ?? '',
        pushToken: json["push_token"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "about": about,
        "created_at": createdAt,
        "last_active": lastActive,
        "is_online": isOnline,
        "id": id,
        "email": email,
        "push_token": pushToken,
      };
}
