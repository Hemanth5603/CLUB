import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/eventModel.dart';
import '../model/ticketModel.dart';

class EventController extends GetxController {
  // final personalName = TextEditingController();
  // final phoneNo = TextEditingController();
  // var gender = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) {
    return _db.collection('events').doc(event.eventId).set(event.toMap());
  }

  Future<void> purchaseTicket(Ticket ticket) async {
    try {
      final batch = _db.batch();

      final ticketRef = _db
          .collection('tickets')
          .doc(ticket.eventId)
          .collection('customers')
          .doc(ticket.ticketId);
      batch.set(ticketRef, ticket.toMap());

      final eventRef = _db.collection('events').doc(ticket.eventId);
      batch.update(eventRef, {
        'available_seats': FieldValue.increment(-ticket.personDetails.length),
      });

      await batch.commit();
      Get.snackbar('Success', 'Success', backgroundColor: Colors.green);
    } catch (e) {
      Get.snackbar('Error', "Error");
      print(e);
    }
  }

  Stream<List<Event>> getEvents() {
    return _db.collection('events').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<Ticket>> getEventTickets(String eventId) {
    return _db
        .collection('tickets')
        .doc(eventId)
        .collection('customers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Ticket.fromMap(doc.data())).toList();
    });
  }
}
