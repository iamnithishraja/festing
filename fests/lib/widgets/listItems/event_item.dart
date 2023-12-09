import 'package:fests/models/event.dart';
import 'package:fests/models/order.dart';
import 'package:fests/models/user.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/screens/orders/userScreens/serchTeam.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EventItem extends ConsumerWidget {
  EventItem(this.event, {super.key});
  Event event;

  String formattedDateTime(DateTime item) {
    return item.hour >= 12
        ? item.hour == 12
            ? "${item.hour.toString()}:${item.minute.toString()} pm"
            : "${(item.hour - 12).toString()}:${item.minute.toString()} pm"
        : "${item.hour.toString()}:${item.minute.toString()} am";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void viewSchedule() {
      showDialog(
        context: context,
        builder: (context) {
          int day = 1;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.white)),
            shadowColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            alignment: Alignment.center,
            title: Column(
              children: [
                Heading(str: "Schedule", alignment: TextAlign.center),
                SubHeading(str: "${event.name}")
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...event.scedule.map((timings) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubHeading(str: "Day ${day++}"),
                        SubHeading(str: "${formattedDateTime(timings[0])}"),
                        SubHeading(str: "${formattedDateTime(timings[1])}")
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          );
        },
      );
    }

    void completeRegistration() async {
      Order order = await ref
          .read(OrdersProvider.notifier)
          .createOrder(eventId: event.id, userId: ref.watch(userProvider)!.id);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => serchTeamMates(order),
      ));
    }

    bool isRegistered() {
      final orders = ref.watch(OrdersProvider);
      for (var order in orders) {
        if (order.event.id == event.id) {
          return true;
        }
      }
      return false;
    }

    final registeredEvents = ref.read(OrdersProvider);
    DateTime startDate = event.scedule.first[0];
    DateTime endDate = event.scedule.last[1];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 200,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Image.network(
              event.image,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Heading(
                    str: event.name,
                    fontSize: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SubHeading(
                    str: event.description,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                ExpansionTile(
                  title: SubHeading(
                    str: "More Details",
                  ),
                  subtitle: SubHeading(
                    str: "click to view more details about this event",
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                  children: [
                    Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: event.details.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              radius: 20,
                              child: SubHeading(str: "${index + 1}"),
                            ),
                            title: SubHeading(str: event.details[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.green,
                      ),
                      label: SubHeading(
                          str:
                              "${DateFormat("EEEE\ndd-MM-yyyy").format(startDate)}",
                          fontSize: 13,
                          color: Colors.green),
                    ),
                    TextButton.icon(
                      onPressed:
                          event.scedule.length == 1 ? () {} : viewSchedule,
                      icon: Icon(
                        Icons.watch_later,
                        color: Colors.white,
                      ),
                      label: SubHeading(
                          str: event.scedule.length == 1
                              ? "${formattedDateTime(event.scedule.first.first)}\n${formattedDateTime(event.scedule.last.last)}"
                              : "view\nschedule",
                          fontSize: 13),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.red,
                      ),
                      label: SubHeading(
                        str:
                            "${DateFormat("EEEE\ndd-MM-yyyy").format(endDate)}",
                        fontSize: 13,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.category,
                        color: Colors.white,
                      ),
                      label: SubHeading(
                          str: event.category.split(" ").length == 1
                              ? "${event.category}"
                              : "${event.category.split(" ")[0]}\n${event.category.split(" ")[1]}",
                          fontSize: 16),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      label: SubHeading(
                        str: "Team\n${event.teamSize}",
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        if (event.mapsLink == null) return;
                        launchUrl(Uri.parse(event.mapsLink!));
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: SubHeading(
                          str: event.venue.split(" ").length == 1
                              ? "${event.venue}"
                              : "${event.venue.split(" ")[0]}\n${event.venue.split(" ")[1]}",
                          fontSize: 16),
                    )
                  ],
                ),
                SizedBox(height: 5),
                isRegistered() == false
                    ? SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white)),
                                  title: Heading(str: "Confirm Registration"),
                                  shadowColor:
                                      Theme.of(context).colorScheme.secondary,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  content: SubHeading(
                                      str:
                                          "you sure you want to register for this event?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: SubHeading(
                                          str: "Cancel",
                                          color: Colors.red,
                                        )),
                                    TextButton(
                                        onPressed: completeRegistration,
                                        child: SubHeading(
                                          str: "Confirm",
                                          color: Colors.green,
                                        ))
                                  ]),
                            );
                          },
                          child: Heading(
                            str: "Register",
                            fontSize: 28,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(97, 63, 216, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: SubHeading(
                          str: "alredy registered for this event",
                          color: Colors.red,
                          align: TextAlign.center,
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
