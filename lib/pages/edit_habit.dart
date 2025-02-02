// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:habit_app/components/input_field.dart';
// import 'package:habit_app/model/Database.dart';
// import 'package:provider/provider.dart';
//
// class EditHabit extends StatefulWidget {
//   final String id;
//   const EditHabit({super.key, required this.id});
//
//   @override
//   State<EditHabit> createState() => _EditHabitState();
// }
//
// class _EditHabitState extends State<EditHabit> {
//   final List<String> habit_items = ['Good habit', 'Bad habit'];
//   final List<String> type_items = ['yes or no', 'value'];
//   late TextEditingController habit_controller;
//   late TextEditingController desc_controller;
//   late TextEditingController threshold_controller;
//   late bool isGood;
//   late bool type = false;
//   String? selected_category;
//   String? selected_type;
//   late Map<String, dynamic> habit_data;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize controllers
//     habit_controller = TextEditingController();
//     desc_controller = TextEditingController();
//     threshold_controller = TextEditingController();
//
//     // Fetch the habit data and initialize the fields
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final db = Provider.of<Database>(context, listen: false);
//
//       final habit = db.MyHabits.firstWhere((x) => x['id'] == widget.id);
//
//       setState(() {
//         // Initialize fields with habit data
//         habit_controller.text = habit['name'];
//         desc_controller.text = habit['description'];
//         isGood = habit['isGood'];
//         type = habit['type'];
//         selected_type = type ? 'yes or no' : 'value';
//         selected_category = isGood ? 'Good habit' : 'Bad habit';
//         threshold_controller.text = habit['threshold']?.toString() ?? "";
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     habit_controller.dispose();
//     desc_controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Database>(
//         builder: (context, value, child) => Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//               ),
//               body: SingleChildScrollView(
//                 child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // heading
//                         Text(
//                           "Edit your habit",
//                           style: GoogleFonts.varelaRound(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//
//                         SizedBox(
//                           height: 20,
//                         ),
//
//                         // habit category
//                         Container(
//                           padding: EdgeInsets.all(10),
//                           child: Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Habit category",
//                                     style: GoogleFonts.varelaRound(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   DropdownButtonHideUnderline(
//                                     child: DropdownButton2<String>(
//                                       isExpanded: true,
//                                       hint: Text(
//                                         'Select Item',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Theme.of(context).hintColor,
//                                         ),
//                                       ),
//                                       value: selected_category,
//                                       items: habit_items
//                                           .map((String item) =>
//                                               DropdownMenuItem<String>(
//                                                 value: item,
//                                                 child: Text(item,
//                                                     style:
//                                                         GoogleFonts.varelaRound(
//                                                             color:
//                                                                 Colors.white)),
//                                               ))
//                                           .toList(),
//                                       onChanged: (String? category_value) {
//                                         setState(() {
//                                           selected_category = category_value;
//                                           category_value == "Good habit"
//                                               ? isGood = true
//                                               : isGood = false;
//                                         });
//                                       },
//                                       buttonStyleData: ButtonStyleData(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 16),
//                                           height: 40,
//                                           width: 150,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white10,
//                                               borderRadius:
//                                                   BorderRadius.circular(12))),
//                                       menuItemStyleData:
//                                           const MenuItemStyleData(
//                                         height: 40,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 20,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "Habit type",
//                                     style: GoogleFonts.varelaRound(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                   DropdownButtonHideUnderline(
//                                     child: DropdownButton2<String>(
//                                       isExpanded: true,
//                                       hint: Text(
//                                         'Select Item',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Theme.of(context).hintColor,
//                                         ),
//                                       ),
//                                       items: type_items
//                                           .map((String item) =>
//                                               DropdownMenuItem<String>(
//                                                 value: item,
//                                                 child: Text(item,
//                                                     style:
//                                                         GoogleFonts.varelaRound(
//                                                             color:
//                                                                 Colors.white)),
//                                               ))
//                                           .toList(),
//                                       value: selected_type,
//                                       onChanged: (String? type_value) {
//                                         setState(() {
//                                           type_value == "yes or no"
//                                               ? type = true
//                                               : type = false;
//                                           selected_type = type_value;
//                                         });
//                                       },
//                                       buttonStyleData: ButtonStyleData(
//                                           padding: EdgeInsets.symmetric(
//                                               horizontal: 16),
//                                           height: 40,
//                                           width: 150,
//                                           decoration: BoxDecoration(
//                                               color: Colors.white10,
//                                               borderRadius:
//                                                   BorderRadius.circular(12))),
//                                       menuItemStyleData:
//                                           const MenuItemStyleData(
//                                         height: 40,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 15,
//                               ),
//                               (type == false)
//                                   ? InputField(
//                                       controller: threshold_controller,
//                                       hint: "threshold")
//                                   : Container()
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.grey[900]),
//                           child: RichText(
//                             text: TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: "note   \n",
//                                   style: GoogleFonts.varelaRound(
//                                       color: Colors
//                                           .blue), // Different color for "note"
//                                 ),
//                                 TextSpan(
//                                   text:
//                                       "use negative sentences for bad habits and positive sentences "
//                                       "for good habits.\neg.\ngood habit - go to the gym \n"
//                                       "bad habit - don't drink",
//                                   style: GoogleFonts.varelaRound(
//                                       color: Colors.grey[
//                                           500]), // Style for the rest of the text
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(
//                           height: 30,
//                         ),
//                         InputField(
//                           controller: habit_controller,
//                           hint: "Habit",
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         InputField(
//                           controller: desc_controller,
//                           hint: "Description",
//                         ),
//                         SizedBox(
//                           height: 40,
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             DateTime date = DateTime.now();
//                             String today =
//                                 "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
//                            Map<String,dynamic> newHabit =  {
//                              'name':habit_controller.text,
//                              'isGood':isGood,
//                              'description':desc_controller.text,
//                              'type':type,
//                              'threshold': (type)
//                                     ? null
//                                       : int.parse(threshold_controller.text),
//                              'completed_dates':{
//                                today:[false,0]
//                              }
//
//
//                            };
//
//                               final dbs = context.read<Database>();
//                                 dbs.updateHabit(widget.id, newHabit);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text("Habit added successfully!"),
//                                 backgroundColor: Colors.green,
//                                 duration: Duration(
//                                     seconds: 2), // Visible for 2 seconds
//                               ),
//                             );
//
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: 10, horizontal: 40),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10),
//                                 color: Colors.blue),
//                             child: Text("Add"),
//                           ),
//                         )
//                       ],
//                     )),
//               ),
//             ));
//
//     // Access the locally stored habits
//   }
// }
