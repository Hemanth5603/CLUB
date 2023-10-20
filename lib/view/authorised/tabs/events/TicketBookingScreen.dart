import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';
import '../../../../controllers/event_controller.dart';
import '../../../../model/eventModel.dart';
import '../../../../model/ticketModel.dart';

class TicketBookingScreen extends StatefulWidget {
  final Event event;

  TicketBookingScreen({required this.event});

  @override
  _TicketBookingScreenState createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> with TickerProviderStateMixin {
  int ticketQuantity = 1;
  String selectedTicketType = '';
  List<PersonDetails> personDetails = [];
  String? gender;
  bool isDropFocus = false;
  bool bottomSheet = false;
  double selectedTicketPrice = 0;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      bottomSheet: bottomSheet?BottomSheet(
        animationController: _controller,
        backgroundColor: Colors.grey[200],
        constraints: BoxConstraints.tight( Size(w,h * 0.35)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        enableDrag: true,
        showDragHandle: true,
        dragHandleColor: Colors.black,
        dragHandleSize: Size(w,h * 0.01),
        builder:(context) =>  Stack(
          children: [
            SizedBox(
              height: h * 0.35,
              width: w * 0.8,
            ),
              Positioned(
                top: h * 0.129,
                left: w * 0.05,
                right: w * 0.05,
              child: Container(
                width: w * 0.75,
                height: h * 0.05,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(20),
                  color: Colors. white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    )
                  ]
                ),
              ),
            ),
            SizedBox(
              height: h * 0.35,
              width: w * 0.8,
                child: Center(
                  child: NumberPicker(
                    itemCount: 5,
                    minValue: 1,maxValue: widget.event.availableSeats,
                  value: ticketQuantity,
                  textStyle:  TextStyle(color: Colors.grey[500],fontFamily: 'metro',fontSize: 16),
                  selectedTextStyle:const TextStyle(color: Colors.black,fontFamily: 'metro',fontSize: 18),
                  onChanged: (value) => setState((){
                    ticketQuantity = value;
                  }),
                ),
              ),
            ),
          ],
        ),
        onClosing: (){
          setState(() {
            bottomSheet = !bottomSheet;
          });
        },
      ) : null,
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        physics:const PageScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: h * 0.386,
              width: w,
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: DecorationImage(
                      image: NetworkImage(widget.event.imageUrl),
                      fit: BoxFit.cover),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)
                      )
                    ),
            ),
            SizedBox(
              height: h * 0.015,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: h * 0.25,
                  width: w * 0.965,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            height: h * 0.105,
                            width: w * 965,
                            // color: Colors.amberAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8.0, left: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        // color: Colors.red,
                                        height: h * 0.04,
                                        width: w * 0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              size: h * 0.035,
                                            ),
                                            Text(
                                              widget.event.location,
                                              style: const TextStyle(
                                                  fontFamily: 'metro',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 8.0),
                                        child: Text(
                                          widget.event.name,
                                          style: const TextStyle(
                                              fontFamily: 'metro',
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, left: 15),
                                  child: Container(
                                    height: h * 0.08,
                                    width: w * 0.15,
                                    decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat.MMM().format(DateTime(
                                                widget
                                                    .event.dateAndTime.month)),
                                            style: const TextStyle(
                                                fontFamily: 'metro',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            widget.event.dateAndTime.day
                                                .toString(),
                                            style: const TextStyle(
                                                fontFamily: 'metro',
                                                fontSize: 16),
                                          ),
                                        ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Flex(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            children: List.generate(40, (_) {
                              return SizedBox(
                                height: h * 0.002,
                                width: w * 0.008,
                                child: DecoratedBox(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[300]),
                                ),
                              );
                            }),
                          ),
                        ),
                        Container(
                          height: h * 0.104,
                          width: w * 0.965,
                          // color: Colors.black,
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  widget.event.description,
                                  style: const TextStyle(
                                      fontFamily: 'metro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w100),
                                ),
                              ),
                              if (ticketQuantity == 1)
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        bottomSheet = !bottomSheet;
                                      });
                                    },
                                    child: Text(
                                      "$ticketQuantity Ticket",
                                      style: const TextStyle(
                                          fontFamily: 'metro',
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                              else
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      bottomSheet = !bottomSheet;
                                    });
                                  },
                                  child: Text(
                                    "$ticketQuantity Tickets",
                                    style: const TextStyle(
                                        fontFamily: 'metro',
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                            ],
                          ),
                        )
                      ]),
                ),
                Positioned(
                    left: -w * 0.511,
                    child: Container(
                      height: h * 0.025,
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], shape: BoxShape.circle),
                    )),
                Positioned(
                    right: -w * 0.51,
                    child: Container(
                      height: h * 0.025,
                      width: w,
                      decoration: BoxDecoration(
                          color: Colors.grey[300], shape: BoxShape.circle),
                    ))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            ...widget.event.ticketPrices.entries.map((entry) {
              return Container(
                height: h * 0.09,
                width: w * 0.965,
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Radio(
                        splashRadius: 0,
                        activeColor: Colors.black,
                        value: entry.key,
                        groupValue: selectedTicketType,
                        onChanged: (value) {
                          selectedTicketPrice = entry.value;
                          setState(() {
                            selectedTicketType = value.toString();
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: h * 04,
                          width: w * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontFamily: 'metro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: h * 0.07,
                                    width: w * 0.18,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                        child: Text(
                                      "₹${entry.value}",
                                      style: const TextStyle(
                                          fontFamily: 'metro',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    )),
                                  ),
                                )
                              ]),
                        ),
                      )
                    ]),
              );
            }).toList(),
            // tableReservationDateGuest(context)
          ],
        ),
      ),
      bottomNavigationBar:bottomSheet?null : Container(
        height: h * 0.09,
        width: w * 0.35,
        padding: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () {
            _bookTicket();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Book Ticket ',
                style: TextStyle(
                    fontFamily: 'metro',
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "₹${selectedTicketPrice * ticketQuantity}",
                style: const TextStyle(
                    fontFamily: 'metro',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget personalDetailsTextField(
      {required final controller, required final name, required keybordtype}) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return SizedBox(
      height: h * 0.07,
      width: w * 0.8,
      child: Center(
        child: TextField(
          controller: controller,
          keyboardType: keybordtype,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              labelText: name,
              labelStyle: const TextStyle(
                  fontFamily: 'sen', fontSize: 16, color: Colors.redAccent),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.redAccent))),
        ),
      ),
    );
  }

  void _bookTicket() {
    final eventController = Get.find<EventController>();
    eventController.purchaseTicket(Ticket(
        ticketId: const Uuid().v4(),
        eventId: widget.event.eventId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        ticketType: selectedTicketType,
        purchaseDate: DateTime.now(),
        totalPrice: selectedTicketPrice * ticketQuantity,
        personDetails: personDetails));
  }
}
