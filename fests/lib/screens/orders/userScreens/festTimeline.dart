import 'dart:math';

import 'package:fests/models/event.dart';
import 'package:fests/providers/eventProvider.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:fests/widgets/timeline/timelineTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FestTimelineScreen extends ConsumerStatefulWidget {
  const FestTimelineScreen({super.key});

  @override
  ConsumerState<FestTimelineScreen> createState() => _FestTimelineScreenState();
}

class _FestTimelineScreenState extends ConsumerState<FestTimelineScreen> {
  int day = 1;
  final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<Map<String, dynamic>>> timelines = [];

    List<Event> events = ref.watch(eventProvider);
    List<Event> filteredEvents = [];
    int dayslength = 0;
    events.forEach((event) {
      if (event.scedule.length >= day) {
        filteredEvents.add(event);
        dayslength = max(event.scedule.length, dayslength);
      }
    });
    filteredEvents.sort(
        (a, b) => a.scedule[day - 1].first.compareTo(b.scedule[day - 1].first));

    for (final event in filteredEvents) {
      DateTime startTime = event.scedule[day - 1].first;
      bool isEventAdded = false;
      for (var i = 0; i < timelines.length; i++) {
        DateTime endTime = timelines[i].last["endTime"];
        if (endTime.isAtSameMomentAs(startTime)) {
          timelines[i].add({
            "startTime": startTime,
            "endTime": endTime,
            "name": event.name,
            "category": event.category
          });
          isEventAdded = true;
          break;
        }
        if (startTime.isAfter(endTime)) {
          timelines[i] = [
            ...timelines[i],
            {
              "name": "break",
              "category": "break",
              "startTime": timelines[i].last["endTime"],
              "endTime": startTime,
            },
            {
              "startTime": startTime,
              "endTime": event.scedule[day - 1].last,
              "name": event.name,
              "category": event.category
            }
          ];
          isEventAdded = true;
          break;
        }
      }
      if (timelines.length == 0) {
        timelines.add([
          {
            "startTime": startTime,
            "endTime": event.scedule[day - 1].last,
            "name": event.name,
            "category": event.category,
          }
        ]);
      } else if (isEventAdded == false) {
        timelines.add([
          {
            "startTime": filteredEvents[0].scedule[day - 1].first,
            "endTime": startTime,
            "name": "break",
            "category": "break",
          },
          {
            "startTime": startTime,
            "endTime": event.scedule[day - 1].last,
            "name": event.name,
            "category": event.category,
          }
        ]);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Day $day"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (day != 1) {
                  day--;
                }
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                if (day!=dayslength) {
                  day++;
                }
              });
            },
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ],
      ),
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: timelines.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 20),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                controller: _controller,
                itemBuilder: (context, idx) {
                  bool islast = idx == timelines[index].length - 1;
                  final event = timelines[index][idx];
                  final startTime = event["startTime"] as DateTime;
                  final endTime = event["endTime"] as DateTime;
                  return TimelineTile(
                    isLast: islast,
                    nodeSubtitle: event["category"],
                    nodeTitle: event["name"],
                    height: 1.2 *
                        endTime.difference(startTime).inMinutes.toDouble(),
                    startTime: startTime,
                    endTime: endTime,
                  );
                },
                itemCount: timelines[index].length,
              ),
            );
          },
        ),
      ),
    );
  }
}
