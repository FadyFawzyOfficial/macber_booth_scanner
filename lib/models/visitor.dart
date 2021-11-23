import 'dart:convert';

class Visitor {
  String id;
  String name;
  String job;
  String phone;
  String salesMan;

  Visitor({
    required this.id,
    required this.name,
    required this.job,
    required this.phone,
    required this.salesMan,
  });

  factory Visitor.fromMap(Map<String, dynamic> map) {
    return Visitor(
      id: map['id'],
      name: map['name'],
      job: map['job'],
      phone: map['phone'],
      salesMan: map['salesMan'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'job': job,
      'phone': phone,
      'salesMan': salesMan,
    };
  }

  String toJson() => json.encode(toMap());

  factory Visitor.fromJson(String source) =>
      Visitor.fromMap(json.decode(source));
}
