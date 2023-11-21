import 'package:supashop/entities/entity.dart';

enum AddressType { unknown, home, work, other }

class Address extends Entity {
  String name;
  String? country;
  String? state;
  String? city;
  String? neighborhood;
  String? street;
  String? number;
  String? complement;
  String? zipCode;
  double? latitude;
  double? longitude;
  AddressType type;

  Address({
    super.id,
    String? name,
    this.zipCode,
    this.complement,
    this.number,
    this.street,
    this.city,
    this.country,
    this.neighborhood,
    this.state,
    this.latitude,
    this.longitude,
    this.type = AddressType.unknown,
  }) : name = name ?? type.name;

  @override
  String toString() {
    return [
      if (number != null) number,
      if (street != null) street,
      if (city != null) city,
      if (country != null) country,
      if (neighborhood != null) neighborhood,
      if (state != null) state,
      if (zipCode != null) zipCode,
    ].join(', ');
  }

  static Address fromJson(json) {
    return Address(
      zipCode: json?['zip_code'],
      number: json?['number'],
      street: json?['street'],
      neighborhood: json?['neighborhood'],
      city: json?['city'],
      state: json?['state'],
      country: json?['country'],
      latitude: json?['latitude'],
      longitude: json?['longitude'],
      type: AddressType.values[json?['type'] ?? 0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zip_code': zipCode,
      'number': number,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'type': type.index,
    };
  }
}