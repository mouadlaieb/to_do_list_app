import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/add_note_page.dart';
import 'package:todo_app/components/taskwidget.dart';
import 'package:todo_app/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Model>(create: (_) => Model()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Consumer<Model>(
        builder: (context, model, child) {
          final tasksForSelectedDay =
              selectedDay != null ? model.getTasksForDay(selectedDay!) : [];

          return Column(
            children: [
              // Horizontal Day Selector
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.days.length,
                  itemBuilder: (context, index) {
                    final day = model.days[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = day;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: selectedDay == day
                              ? Colors.blue
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(1000.0),
                        ),
                        child: Center(
                          child: Text(
                            day, // Now displays "Sunday, November 11"
                            style: TextStyle(
                              color: selectedDay == day
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Task List for the Selected Day
              Expanded(
                child: tasksForSelectedDay.isNotEmpty
                    ? ListView.builder(
                        itemCount: tasksForSelectedDay.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TaskWidget(
                            task: tasksForSelectedDay[index],
                          );
                        },
                      )
                    : const Center(child: Text('No tasks for this day')),
              ),
            ],
          );
        },
      ),
      // Floating Action Button to Add Task
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
