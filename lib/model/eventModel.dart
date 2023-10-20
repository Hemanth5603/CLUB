import 'dart:convert';

class Event {
  final String eventId;
  final String hostId;
  final String name;
  final String description;
  final DateTime dateAndTime;
  final String location;
  final Map<String, double> ticketPrices;
  final int availableSeats;
  final String imageUrl;

  Event({
    required this.eventId,
    required this.hostId,
    required this.name,
    required this.description,
    required this.dateAndTime,
    required this.location,
    required this.ticketPrices,
    required this.availableSeats,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventId': eventId,
      'hostId': hostId,
      'name': name,
      'description': description,
      'dateAndTime': dateAndTime.millisecondsSinceEpoch,
      'location': location,
      'ticketPrices': ticketPrices,
      'availableSeats': availableSeats,
      'imageUrl': imageUrl,
    };
  }

factory Event.fromMap(Map<String, dynamic> map) {
  return Event(
    eventId: map['eventId'] as String,
    hostId: map['hostId'] as String,
    name: map['name'] as String,
    description: map['description'] as String,
    dateAndTime: DateTime.fromMillisecondsSinceEpoch(map['dateAndTime'] as int),
    location: map['location'] as String,
    ticketPrices: _parseTicketPrices(map['ticketPrices']),
    availableSeats: map['availableSeats'] as int,
    imageUrl: map['imageUrl'] as String,
  );
}

static Map<String, double> _parseTicketPrices(dynamic value) {
  if (value is Map<String, double>) {
    return value;
  } else if (value is Map<String, dynamic>) { 
    return value.map((key, dynamic val) => MapEntry(key, val as double));
  } else { 
    return {};
  }
}

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) => Event.fromMap(json.decode(source) as Map<String, dynamic>);
}
