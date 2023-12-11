import 'dart:async';
import 'package:fests/models/order.dart';
import 'package:fests/models/user.dart';
import 'package:fests/providers/orderProvider.dart';
import 'package:fests/utils/debouncer.dart';
import 'package:fests/widgets/listItems/useritems/user_tem.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class serchTeamMates extends ConsumerStatefulWidget {
  serchTeamMates(this.order, {super.key});
  Order order;
  @override
  ConsumerState<serchTeamMates> createState() => _serchTeamMatesState();
}

class _serchTeamMatesState extends ConsumerState<serchTeamMates> {
  StreamController<String> streamController = StreamController();
  TextEditingController controller = TextEditingController();

  final _debouncer = Debouncer(milliseconds: 500);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    _debouncer.dispose();
  }

  bool sentRequest = false;
  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add TeamMates"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            SearchBar(
              hintText: "Enter Name OR Roll Number",
              hintStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(color: Colors.white38)),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.background),
              textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(color: Colors.white)),
              controller: controller,
              onChanged: (value) {
                _debouncer.run(() => ref
                    .watch(allUsersProvider.notifier)
                    .getAllUsers(keyword: controller.text));
              },
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
            ),
            SizedBox(
              height: 5,
            ),
            SubHeading(
              str:
                  "if add more than ${widget.order.event.teamSize - 1} people the first person to accept request will be added to your team",
              align: TextAlign.center,
              color: Colors.yellow,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: showFab
                  ? MediaQuery.of(context).size.height * 0.66
                  : MediaQuery.of(context).size.height * 0.75 -
                      MediaQuery.of(context).viewInsets.bottom,
              child: FutureBuilder(
                future: controller.text == ""
                    ? ref.watch(allUsersProvider.notifier).getAllUsers()
                    : ref
                        .watch(allUsersProvider.notifier)
                        .getAllUsers(keyword: controller.text),
                builder: (context, snapshot) {
                  final users = ref.watch(allUsersProvider);
                  if (users.length == 0) {
                    return Center(
                      child: SubHeading(
                        str:
                            "No Users Found\nPlease Make Sure!\nYour TeamMates Have An Account",
                        align: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return UserItem(
                        order: widget.order,
                        user: users[index],
                      );
                    },
                    itemCount: users.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Fluttertoast.showToast(
                    msg: "Successfully Sent Requests",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  ref
                      .read(OrdersProvider.notifier)
                      .getAllOrders(ref.watch(userProvider)!.id);
                },
                child: Heading(
                  str: "Finish Up",
                  fontSize: 28,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
