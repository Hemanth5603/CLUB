import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/event_controller.dart';
import '../../../../model/eventModel.dart';
import 'TicketBookingScreen.dart';

class EventListScreen extends StatefulWidget {
  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final EventController _eventController = Get.put(EventController());
  String selectedTicketType = '';

  double selectedTicketPrice = 0;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: h * 0.99,
              width: w * 1.00,
            ),
            Positioned(
              top: h * 0.08,
              left: w * 0.02,
              right: w * 0.03,
              child: Container(
                height: h * 0.99,
                width: w * 0.97,
                decoration: BoxDecoration(color: Colors.grey[200],
                borderRadius:const BorderRadius.only(topRight: Radius.circular(10))
                ),
                child: StreamBuilder<List<Event>>(
                  stream: _eventController.getEvents(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    if (snapshot.hasData) {
                      List<Event> events = snapshot.data!;
                      return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                    () => TicketBookingScreen(
                                          event: events[index],
                                        ),
                                    transition: Transition.downToUp);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: h * 0.25,
                                    width: w * 0.9,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                events[index].imageUrl),
                                            fit: BoxFit.cover),
                                        color: Colors.black26,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    padding: EdgeInsets.only(
                                        top: h * 0.017,
                                        bottom: h * 0.16,
                                        right: w * 0.02,
                                        left: w * 0.74),
                                    child: Container(
                                        height: h * 0.05,
                                        width: w * 0.2,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat.MMM().format(DateTime(
                                                  events[index]
                                                      .dateAndTime
                                                      .month)).toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'metro',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              events[index].dateAndTime.day.toString(),
                                              style: const TextStyle(
                                                fontFamily: 'metro',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  Container(
                                    height: h * 0.17,
                                    width: w * 0.9,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(29))),
                                    child: Column(children: [
                                      SizedBox(
                                        height: h * 0.04,
                                        // color: Colors.amberAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, top: 2),
                                              child: SizedBox(
                                                height: h * 0.04,
                                                width: w * 0.69,
                                                // color: Colors.blue,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_sharp,
                                                      color: Colors.black,
                                                      size: h * 0.023,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                        width: w * 0.51,
                                                        child: Text(
                                                            events[index]
                                                                .location.toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'metro',
                                                                fontSize:
                                                                    h * 0.023,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors.black),
                                                            overflow:
                                                                TextOverflow.ellipsis))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: h * 0.13,
                                        width: w * 0.9,
                                        decoration: BoxDecoration(
                                            // color: Colors.cyan,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 3, right: 3),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Text(
                                                        events[index].name.toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: 'metro',
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 1,
                                                              left: 145),
                                                      child: Text(
                                                          "₹${events[index].ticketPrices[events[index].ticketPrices.keys.toList().first]}"),
                                                    )
                                                    // ...events[index].ticketPrices
                                                    //     .entries
                                                    //     .map((entry) {
                                                    //   return ListTile(
                                                    //     title: Text(entry.key),
                                                    //     subtitle: Text(
                                                    //         'Price: ${entry.value}'),
                                                    //     leading: Radio(
                                                    //       value: entry.key,
                                                    //       groupValue:
                                                    //           selectedTicketType,
                                                    //       onChanged: (value) {
                                                    //         selectedTicketPrice =
                                                    //             entry.value;
                                                    //         setState(() {
                                                    //           selectedTicketType =
                                                    //               value
                                                    //                   .toString();
                                                    //         });
                                                    //       },
                                                    //     ),
                                                    //   );
                                                    // }).toList(),
                                                  ],
                                                ),
                                                const Divider(
                                                  color: Colors.black,
                                                ),
                                                Container(
                                                  height: h * 0.05,
                                                  width: w * 0.90,
                                                  // color: Colors.yellow,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, right: 2),
                                                  child: Text(
                                                    events[index].description,
                                                    style: const TextStyle(
                                                        fontFamily: 'metro',
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    maxLines: 2,
                                                  ),
                                                )
                                              ]),
                                        ),
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      ));
                    }
                  },
                ),
              ),
            ),
            Positioned(
                top: h * 0.02,
                left: w * 0.02,
                child: Container(
                  height: h * 0.06,
                  width: w * 0.32,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Center(
                      child: Text(
                    "Events",
                    style: TextStyle(
                      fontFamily: 'metro',
                      fontSize: h * 0.024,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                )),
          ],
        ),
      ),
    );
  }
}
