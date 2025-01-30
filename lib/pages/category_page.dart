import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Map<String, double> dataMap = {"Good habits done": 70, "Bad habits done": 30};

  // List of motivational quotes
  final List<String> quotes = [
    "Discipline is the bridge between goals and accomplishment.",
    "Consistency is what transforms average into excellence.",
    "Success doesn't come from what you do occasionally, but what you do consistently.",
    "Motivation gets you started, discipline keeps you going.",
    "Small disciplines repeated daily lead to big results.",
    "The secret to success is in your daily routine.",
    "Don't stop until you're proud.",
    "Success is the sum of small efforts repeated day in and day out.",
    "You don’t need to be perfect, just consistent.",
    "Push yourself because no one else is going to do it for you."
  ];

  int currentQuoteIndex = 0;

  @override
  void initState() {
    super.initState();
    startQuoteRotation();
  }

  void startQuoteRotation() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentQuoteIndex = (currentQuoteIndex + 1) % quotes.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 25),

              // Graph Title
              sectionTitle("Graph 📊"),
              const SizedBox(height: 20),

              // Pie Chart
              Center(
                child: PieChart(
                  legendOptions: LegendOptions(
                    legendPosition: LegendPosition.bottom,
                    legendTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  chartType: ChartType.disc,
                  chartRadius: 180,
                  dataMap: dataMap,
                  colorList: [
                    Colors.blueAccent,
                    Colors.grey,
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats Title
              sectionTitle("Stats 📈"),
              const SizedBox(height: 20),

              // Stats Container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      habitInfoRow("Average Habit Color", ""),
                      const SizedBox(height: 16),
                      habitInfoRow("Total Habits", "8"),
                      const SizedBox(height: 12),
                      habitInfoRow("Total Bad Habits", "6"),
                      const SizedBox(height: 12),
                      habitInfoRow("Total Good Habits", "2"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Motivational Quote
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: Container(
                  key: ValueKey(currentQuoteIndex),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      quotes[currentQuoteIndex],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
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

  Widget sectionTitle(String title) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blueGrey[800],
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget habitInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget progressIndicator(String title, double percent, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          value: percent,
          color: color,
          backgroundColor: Colors.grey[700],
          strokeWidth: 6,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
