import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/input_field.dart';
import 'package:habit_app/provider/date_color.dart';
import 'package:provider/provider.dart';

import '../model/Database.dart';

class HabitGrid extends StatefulWidget {
  final String title;
  final String id;
  final bool type;
  final int? threshold;
  final bool done;
  final int? current;
  final bool isGood;
  const HabitGrid(
      {super.key,
      required this.title,
      required this.id,
      required this.type,
      required this.done,
      this.current,
      this.threshold,required this.isGood});
  @override
  State<HabitGrid> createState() => _HabitGridState();
}

class _HabitGridState extends State<HabitGrid> {
  TextEditingController value_controller = TextEditingController();

   bool? isChecked = null;
   bool? isGreater = null;
  @override
  void initState() {
    super.initState();

    // Initialize local state variables

    setState(() {
      if (widget.type) {
        isChecked = widget.done;
      } else {
        isGreater = widget.done;
      }

      value_controller.text = widget.current.toString();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Database>(
        builder: (context, value, child) => Container(
              decoration: BoxDecoration(
                color: isGreater == true || isChecked == true
                    ? widget.isGood ? Colors.green.shade400 : Colors.red.shade400
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varelaRound(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    (widget.type == false)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 45,
                                width: 100,
                                child: InputField(
                                    controller: value_controller, hint: ""),
                              ),
                              IconButton(
                                  highlightColor: Colors.green,
                                  onPressed: () {
                                    int? input_text =
                                        int.tryParse(value_controller.text) ??
                                            0;
                                    final db = context.read<Database>();
                                    if (input_text >= widget.threshold!) {
                                      print(
                                          "input = $input_text and threshold = $widget.rate");
                                      setState(() {
                                        isGreater =
                                            true; // Update checkbox state
                                        value_controller.text =
                                            input_text.toString();
                                      });
                                      db.updateChecked(widget.id,
                                          DateTime.now(), true, input_text);
                                      // db.Marked(isChecked, isGreater);
                                    } else {
                                      print(
                                          "input = $input_text and threshold = $widget.rate");
                                      setState(() {
                                        isGreater =
                                            false; // Update checkbox state
                                        value_controller.text =
                                            input_text.toString();
                                      });
                                      db.updateChecked(widget.id,
                                          DateTime.now(), false, input_text);
                                      // db.Marked(isChecked, isGreater);
                                    }
                                    db.calculateColorValueForDate(DateTime.now());
                                  },
                                  icon: Icon(
                                    Icons.done,
                                    color: Colors.blueAccent,
                                  ))
                            ],
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "12⭐️",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          "5🔥",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Transform.scale(
                            scale: 1.5,
                            child: (widget.type == true)
                                ? Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {
                                      final db = context.read<Database>();
                                      db.updateChecked(widget.id,
                                          DateTime.now(), value, null);
                                      setState(() {
                                        isChecked =
                                            value!; // Update checkbox state
                                      });
                                      // db.Marked(isChecked, isGreater);
                                      db.calculateColorValueForDate(DateTime.now());
                                    },
                                  )
                                : Container()),
                      ],
                    ),
                  ],
                ),
              ),
            ));
    ;
  }
}
