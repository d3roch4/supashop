import 'package:uuid/uuid.dart';

class Entity {
  String? id;
  DateTime createdAt;
  DateTime? modifiedAt;

  Entity({String? id, DateTime? createdAt, this.modifiedAt})
      : id = id ?? Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Entity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}