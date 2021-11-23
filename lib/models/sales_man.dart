import 'dart:convert';

class SalesMan {
  String id;
  String name;

  SalesMan({
    required this.id,
    required this.name,
  });

  factory SalesMan.fromMap(Map<String, dynamic> map) {
    return SalesMan(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  String toJson() => json.encode(toMap());

  factory SalesMan.fromJson(String source) =>
      SalesMan.fromMap(json.decode(source));
}
