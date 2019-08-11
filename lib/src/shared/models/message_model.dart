import 'user_model.dart';

class MessageModel {
  UserModel user;
  String content;
  int id;
  DateTime createAt;

  MessageModel({
    this.user,
    this.content,
    this.id,
    this.createAt,
  });
  String get formatedDateTime => "${createAt.day.toString().padLeft(2, "0")}/${createAt.month.toString().padLeft(2, "0")}/${createAt.year.toString().padLeft(2, "0")} ${createAt.hour.toString().padLeft(2, "0")}:${createAt.minute.toString().padLeft(2, "0")}";

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        user: UserModel.fromJson(json["user"]),
        content: json["content"],
        id: json["id"],
        createAt: DateTime.parse(json["create_at"]),
      );

  static List<MessageModel> fromJsonList(List jsonList) {
    if (jsonList == null)
      return null;
    else
      return jsonList
        .map((item) => MessageModel.fromJson(item))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "content": content,
        "id": id,
        "create_at": createAt.toString(),
      };
}
