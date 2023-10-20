// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PersonDetails {
   String name;
   String phone;
   String gender;

  PersonDetails({
    required this.name,
    required this.phone,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'gender': gender,
    };
  }

  factory PersonDetails.fromMap(Map<String, dynamic> map) {
    return PersonDetails(
      name: map['name'] as String,
      phone: map['phone'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonDetails.fromJson(String source) => PersonDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}


class Ticket {
  final String ticketId;
  final String eventId;
  final String userId;
  final String ticketType;
  final DateTime purchaseDate;
  final double totalPrice;
  final List<PersonDetails> personDetails;

  Ticket({
    required this.ticketId,
    required this.eventId,
    required this.userId,
    required this.ticketType,
    required this.purchaseDate,
    required this.totalPrice,
    required this.personDetails,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ticketId': ticketId,
      'eventId': eventId,
      'userId': userId,
      'ticketType': ticketType,
      'purchaseDate': purchaseDate.millisecondsSinceEpoch,
      'totalPrice': totalPrice,
      'personDetails': personDetails.map((x) => x.toMap()).toList(),
    };
  }

 factory Ticket.fromMap(Map<String, dynamic> map) {
  return Ticket(
    ticketId: map['ticketId'] as String,
    eventId: map['eventId'] as String,
    userId: map['userId'] as String,
    ticketType: map['ticketType'] as String,
    purchaseDate: DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'] as int),
    totalPrice: map['totalPrice'] as double,
    personDetails: List<PersonDetails>.from((map['personDetails'] as List<dynamic>).map((x) => PersonDetails.fromMap(x as Map<String, dynamic>))),
  );
}


  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source) as Map<String, dynamic>);
}
