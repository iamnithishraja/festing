import 'package:fests/widgets/texts/heading_text.dart';
import 'package:fests/widgets/texts/sub_heading.dart';
import 'package:flutter/material.dart';

class DetailsAdder extends StatefulWidget {
  DetailsAdder(this.controllers, {Key? key}) : super(key: key);
  List<String>? controllers;
  @override
  State<DetailsAdder> createState() => _DetailsAdderState();
}

class _DetailsAdderState extends State<DetailsAdder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Heading(
            str: "Details",
          ),
          SubHeading(
            str: "<-- swipe delete -->",
            color: Colors.grey,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, idx) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      widget.controllers!.removeAt(idx);
                    });
                  },
                  key: UniqueKey(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      initialValue: widget.controllers![idx],
                      onChanged: (value) => widget.controllers![idx] = value,
                      validator: (value) {
                        if (value == null || value.trim() == '') {
                          return 'required field';
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.list,
                          color: Colors.white,
                        ),
                        label: Text(
                          "detail",
                          style: TextStyle(color: Colors.white),
                        ),
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: widget.controllers!.length,
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                widget.controllers!.add("");
              });
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
    );
  }
}
