import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_app/components/show_habit.dart';
import 'package:habit_app/service/notification_service.dart';
import 'package:provider/provider.dart';

import '../components/text_tile.dart';
import '../model/Database.dart';

class TodayPage extends StatefulWidget {
  TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late Map<DateTime, bool> completed;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "Hey there",
                            style: GoogleFonts.varelaRound(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                        ),
                        // First Text
                        SizedBox(height: 20),
                        Center(child: TextTile(text: "calender")),
                        SizedBox(height: 20),
                        Consumer<Sql>(
                          builder: (context, db, child) {
                            return HeatMapCalendar(
                              // key: ValueKey(db.myGlobaldataset),
                              // Forces rebuild when dataset changes

                              showColorTip: false,
                              textColor: Colors.white,
                              defaultColor: Colors.grey[800],
                              flexible: true,
                              colorMode: ColorMode.color,
                              datasets: db.mydataset,
                              // datasets:{
                              //   DateTime(2025, 1, 1): 7,
                              //   DateTime(2025, 1, 2): 0,
                              //   DateTime(2025, 1, 3): 5,
                              //   DateTime(2025, 1, 4): 1,
                              //   DateTime(2025, 1, 5): 6,
                              //   DateTime(2025, 1, 6): 2,
                              //   DateTime(2025, 1, 7): 3,
                              //   DateTime(2025, 1, 8): 2,
                              //   DateTime(2025, 1, 9): 0,
                              //   DateTime(2025, 1, 10): 7,
                              //   DateTime(2025, 1, 11): 3,
                              //   DateTime(2025, 1, 12): 1,
                              //   DateTime(2025, 1, 13): 0,
                              //   DateTime(2025, 1, 14): 5,
                              //   DateTime(2025, 1, 15): 3,
                              //   DateTime(2025, 1, 16): 2,
                              //   DateTime(2025, 1, 17): 2,
                              //   DateTime(2025, 1, 18): 2,
                              //   DateTime(2025, 1, 19): 7,
                              //   DateTime(2025, 1, 20): 3,
                              //   DateTime(2025, 1, 21): 4,
                              //   DateTime(2025, 1, 22): 5,
                              //   DateTime(2025, 1, 23): 4
                              // },


                              colorsets: {
                                1: Colors.red.shade500,
                                2: Colors.red.shade300,
                                3: Colors.red.shade200,
                                4: Colors.blueAccent,
                                5: Colors.green.shade200,
                                6: Colors.green.shade300,
                                7: Colors.green.shade500,
                              },
                              // colorsets: {
                              //   1:Colors.red.shade100,
                              //   2:Colors.orange
                              // },
                              onClick: (value) {
                               print(db.mydataset);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(child: TextTile(text: "Good Habit")),
                            Tab(child: TextTile(text: "Bad Habit")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowHabit(gridtype: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShowHabit(gridtype: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );

  }
}
