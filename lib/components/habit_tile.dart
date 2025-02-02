import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/pages/edit_habit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../model/Database.dart';
import 'habit_pop.dart';

class HabitTile extends StatefulWidget {
  final String habitText;
  final String description;
  final bool isGood;
  final String id;

  final DateTime time;
  final bool type;
  final int? threshold;
  const HabitTile(
      {super.key,
      required this.habitText,
      required this.description,
      required this.isGood,
      required this.id,
      required this.type,
      this.threshold,
        required this.time
     });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return HabitPop(
                  id: widget.id,
                  description: widget.description,
                  name: widget.habitText,
                  type: widget.type,
                  threshold: widget.threshold);
            });
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 6),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration:BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey[900], // Subtle transparency effect
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(2, 4),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 280,
                    child: Text(
                      widget.habitText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.varelaRound(
                          color: Colors.blueAccent, fontSize: 20),
                    ),
                  ),
                  Text(widget.isGood == true ? "Good" : "Bad",
                      style: TextStyle(
                          color: widget.isGood == true
                              ? Colors.green
                              : Colors.red))
                ],
              ),
              Text(
                DateFormat('d MMMM yyyy').format(widget.time),

                style: TextStyle(color: Colors.grey[600], fontSize: 9),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                widget.description,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              SizedBox(
                height: 6,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black26),
                    child: Text(
                      (widget.type == true) ? "boolean" : "value",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => EditHabit(
                        //               id: widget.id,
                        //             )));
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 18,
                      )),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
                    onPressed: () {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.confirm,
                        text: 'Do you want to delete?',
                        confirmBtnText: 'Yes',
                        cancelBtnText: 'No',
                        confirmBtnColor: Colors.green,
                        onCancelBtnTap: () {
                          Navigator.pop(context);
                        },
                        onConfirmBtnTap: () {
                          // final db = context.read<Database>();
                          // db.deleteHabit(widget.id);
                          Navigator.pop(context);
                        },
                      );
                    },
                  )
                ],
              )
            ],
          )),
    );
  }
}
