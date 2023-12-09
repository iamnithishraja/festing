import 'package:fests/screens/events/userScreens/events.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:fests/models/fest.dart';

class FestItem extends ConsumerWidget {
  FestItem(this.fest, {super.key});
  Fest fest;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime startDate =
        DateTime.parse(fest.startDate.split("T")[0].toString());
    DateTime endDate = DateTime.parse(fest.endDate.split("T")[0].toString());
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
              fest.poster,
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
                    str: fest.festName,
                    fontSize: 28,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SubHeading(
                    str: fest.collegeName,
                    fontSize: 24,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: SubHeading(
                    str: fest.description,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse(fest.location));
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: SubHeading(str: "Location", fontSize: 16),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse(fest.collegeWebsite));
                      },
                      icon: Icon(
                        Icons.web,
                        color: Colors.white,
                      ),
                      label: SubHeading(
                        str: "College\nWebsite",
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        if (fest.festWebsite == null) {
                          Fluttertoast.cancel();
                          Fluttertoast.showToast(
                              msg: "no website found for registration",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }
                        launchUrl(Uri.parse(fest.festWebsite!));
                      },
                      icon: Icon(
                        Icons.language,
                        color: Colors.white,
                      ),
                      label: SubHeading(str: "Fest\nWebsite", fontSize: 16),
                    )
                  ],
                ),
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
                    TextButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse(fest.broture));
                      },
                      icon: Icon(
                        Icons.picture_as_pdf,
                        color: Colors.white,
                      ),
                      label: SubHeading(str: "Brochure", fontSize: 13),
                    )
                  ],
                ),
                SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Events(fest: fest),
                    )),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
