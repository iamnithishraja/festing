import 'package:fests/providers/userProvider.dart';
import 'package:fests/screens/posts/CreateNewPost.dart';
import 'package:fests/screens/profile/updateProfile.dart';
import 'package:fests/utils/debouncer.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TextEditingController controller = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  bool showFullBio = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
    _debouncer.dispose();
  }

  bool firstRun = true;
  @override
  Widget build(BuildContext context) {
    if (firstRun) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: "Long Press Profile Picture To Edit Profile",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          timeInSecForIosWeb: 7,
          textColor: Colors.white,
          fontSize: 16.0);
      firstRun = false;
    }
    final user = ref.watch(userProvider);
    final dp = user!.avatar == null
        ? AssetImage("assets/images/profile.png")
        : NetworkImage(user.avatar!);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SearchBar(
                hintText: "Search User",
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
              GestureDetector(
                  onLongPress: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UpdateProfile(),
                      )),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    shadowColor: Theme.of(context).colorScheme.secondary,
                    color: Theme.of(context).colorScheme.background,
                    child: Column(children: [
                      Row(
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(top: 5, left: 5, right: 5),
                              child: CircleAvatar(
                                backgroundImage: dp as ImageProvider,
                                radius: 70,
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Heading(
                                  str: user.name.replaceFirst(" ", "\n"),
                                  alignment: TextAlign.center),
                              SubHeading(str: user.rollno),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          user.socialLinks!["github"]!));
                                    },
                                    icon: Icon(FontAwesomeIcons.github),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(
                                          user.socialLinks!["linkdlin"]!));
                                    },
                                    icon: Icon(FontAwesomeIcons.linkedin),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      launchUrl(Uri.parse(user
                                          .socialLinks!["codingPlatform"]!));
                                    },
                                    icon: Icon(FontAwesomeIcons.code),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      if (user.bio != null)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showFullBio = !showFullBio;
                                });
                              },
                              child: SubHeading(
                                str: showFullBio
                                    ? user.bio!
                                    : (user.bio!.length > 200
                                        ? user.bio!.substring(0, 200) + "..."
                                        : user.bio!),
                                align: TextAlign.center,
                              )),
                        ),
                    ]),
                  )),
              Expanded(
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      shadowColor: Theme.of(context).colorScheme.secondary,
                      color: Theme.of(context).colorScheme.background,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          Container(
                            height: 20,
                            width: 10,
                            child: Card(),
                          );
                        },
                        itemCount: 10,
                      )))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateNewPost(),
          ));
        },
        child: Icon(FontAwesomeIcons.fileArrowUp),
      ),
    );
  }
}
