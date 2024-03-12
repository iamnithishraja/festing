import 'package:fests/models/event.dart';
import 'package:fests/providers/crAddTeamsProvider.dart';
import 'package:fests/widgets/form/detailsAdder.dart';
import 'package:fests/widgets/texts/heading_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class crAddTeamsScreen extends ConsumerStatefulWidget {
  crAddTeamsScreen(this.event);
  Event event;
  @override
  ConsumerState<crAddTeamsScreen> createState() => crAddTeamsState();
}

class crAddTeamsState extends ConsumerState<crAddTeamsScreen> {
  late Event event = widget.event;
  List<String> rollNo = [];
  @override
  Widget build(BuildContext context) {
    void _submitForm() {
      ref.read(crAddTeamsProvider.notifier).addTeam(rollNo, event.id);
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Heading(str: "Add Participents")),
      body: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              DetailsAdder(rollNo),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Heading(
                    str: "Create",
                    fontSize: 28,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
