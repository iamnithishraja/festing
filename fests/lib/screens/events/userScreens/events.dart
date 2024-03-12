import 'package:fests/providers/eventProvider.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/screens/events/adminScreens/CreateEvent.dart';
import 'package:fests/screens/events/adminScreens/UpdateEvent.dart';
import 'package:fests/screens/events/cr%20Screens/crAddTeams.dart';
import 'package:fests/screens/orders/adminScreens/dismissTeam.dart';
import 'package:fests/screens/orders/userScreens/festTimeline.dart';
import 'package:fests/widgets/listItems/event_item.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/models/user.dart';
import 'package:fests/models/fest.dart';
import 'package:fests/models/event.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/listItems/fest_item.dart';

class Events extends ConsumerStatefulWidget {
  Events({required this.fest, super.key});
  Fest fest;
  @override
  ConsumerState<Events> createState() => _EventsState();
}

class _EventsState extends ConsumerState<Events> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider) as User;
    ref.watch(OrdersProvider.notifier).getAllOrders(user.id);

    void longPress(Event event) {
      if (user.role == "cr") {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => EventTeamsScreen(event)));
                },
                icon: Icon(
                  Icons.people,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: SubHeading(
                  str: "Teams",
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => crAddTeamsScreen(event)));
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.green,
                ),
                label: SubHeading(
                  str: "Add Teams",
                  fontSize: 16,
                  color: Colors.green,
                ),
              )
            ],
          ),
        );
      }
      if (user.role != "admin") return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ref.read(eventProvider.notifier).deleteEvent(event.id);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              label: SubHeading(
                str: "Delete",
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => UpdateEvent(event)));
              },
              icon: Icon(
                Icons.edit,
                color: Colors.green,
              ),
              label: SubHeading(
                str: "Edit",
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => EventTeamsScreen(event)));
              },
              icon: Icon(
                Icons.people,
                color: Theme.of(context).colorScheme.secondary,
              ),
              label: SubHeading(
                str: "Teams",
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Heading(str: "${widget.fest.festName} Events"),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FestTimelineScreen(),
            )),
            icon: Icon(Icons.timeline, size: 32),
            color: Colors.white,
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: ref.read(eventProvider.notifier).getEvents(widget.fest.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            final events = ref.watch(eventProvider) as List;
            return RefreshIndicator(
                color: Theme.of(context).colorScheme.secondary,
                onRefresh: () =>
                    ref.read(eventProvider.notifier).getEvents(widget.fest.id),
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () => user.role == "cr"
                              ? longPress(events[index])
                              : user.role == "admin"
                                  ? longPress(events[index])
                                  : () {},
                          child: EventItem(events[index]),
                        );
                      },
                      itemCount: events.length,
                    )));
          }),
      floatingActionButton: (user.role == "admin")
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateEvent(widget.fest),
              )),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            )
          : Container(),
    );
  }
}
