import 'package:fests/providers/festProvider.dart';
import 'package:fests/screens/fests/adminScreens/createFest.dart';
import 'package:fests/screens/fests/adminScreens/updateFest.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fests/models/user.dart';
import 'package:fests/models/fest.dart';
import 'package:fests/providers/userProvider.dart';
import 'package:fests/widgets/listItems/fest_item.dart';

class Fests extends ConsumerStatefulWidget {
  const Fests({super.key});
  final route = "/fests";
  @override
  ConsumerState<Fests> createState() => _FestsState();
}

class _FestsState extends ConsumerState<Fests> {
  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider) as User;
    void longPress(Fest fest) async {
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
                ref.read(festProvider.notifier).deleteFest(fest.id);
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => UpdateFest(fest: fest)));
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
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Heading(str: "Ongoing Fests"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: ref.read(festProvider.notifier).getFests(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            final fests = ref.watch(festProvider) as List;
            return RefreshIndicator(
                color: Theme.of(context).colorScheme.secondary,
                onRefresh: ref.read(festProvider.notifier).getFests,
                child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onLongPress: () => longPress(fests[index]),
                            child: FestItem(fests[index]));
                      },
                      itemCount: fests.length,
                    )));
          }),
      floatingActionButton: (user.role == "admin")
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateFest(),
              )),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            )
          : Container(),
    );
  }
}
