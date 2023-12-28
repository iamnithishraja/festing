import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineTile extends StatelessWidget {
  TimelineTile(
      {required this.isLast,
      required this.nodeSubtitle,
      required this.nodeTitle,
      required this.height,
      required this.startTime,
      required this.endTime,
      super.key});
  bool isLast;
  String nodeTitle;
  String nodeSubtitle;
  double height;
  DateTime startTime;
  DateTime endTime;

  @override
  Widget build(BuildContext context) {
    bool isBreak = nodeSubtitle.toLowerCase() == "break";
    String starttime = DateFormat("h:mma").format(startTime);
    String endtime = DateFormat("h:mma").format(endTime);
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: isBreak
                    ? Colors.red
                    : Theme.of(context).colorScheme.secondary),
            child: Column(
              children: [
                Heading(
                  str: nodeTitle,
                  fontSize: 14,
                ),
                SubHeading(
                  str: nodeSubtitle,
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                height: height,
                color: isBreak
                    ? Colors.red
                    : Theme.of(context).colorScheme.secondary,
                width: 4,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.black54),
                child: SubHeading(
                  str: "$starttime to $endtime",
                  fontSize: 14,
                ),
              ),
            ],
          ),
          !isLast
              ? Container()
              : Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Theme.of(context).colorScheme.secondary),
                  child: Column(
                    children: [
                      Heading(
                        str: "EVENTs END",
                        fontSize: 14,
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
