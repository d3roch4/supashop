import 'entity.dart';

class Account extends Entity {
  String name;
  String email;
  String? phone;
  String? image;
  String? documentNumber;
  bool isAdmin;

  Account({
    super.id,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.documentNumber,
    this.isAdmin = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'documentNumber': documentNumber,
      'isAdmin': isAdmin,
    };
  }

  static fromJson(Map json) {
    return Account(
      id: json['id'],
      name: json['name'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      image: json['image'],
      documentNumber: json['document_number'],
      isAdmin: json['isAdmin'] == true,
    );
  }
}