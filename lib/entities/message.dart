class Message {
  int? id;
  String message;
  String senderId;
  String receiverId;
  DateTime createdAt;

  Message({
    this.id,
    required this.message,
    required this.senderId,
    required this.receiverId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      message: json['message'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'created_at': createdAt.toUtc().toIso8601String(),
    };
  }
}