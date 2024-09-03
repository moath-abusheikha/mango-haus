import 'dart:convert';

Guest guestFromJson(String str) => Guest.fromMap(json.decode(str));

String guestToJson(Guest data) => json.encode(data.toMap());

class Guest {
  String name, passportImagePath, phoneNumber, nationality;

  Guest(this.passportImagePath, this.phoneNumber, this.nationality,
      {required this.name});

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(map['passportImage'], map['PhoneNumber'], map['Nationality'],
        name: map['Name']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'passportImage': passportImagePath,
      'PhoneNumber': phoneNumber,
      'Nationality': nationality,
      'Name': name
    };
    return map;
  }
}
