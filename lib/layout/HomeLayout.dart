import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/modules/ArchiveScreen.dart';
import 'package:todo/modules/DoneScreen.dart';
import 'package:todo/modules/TasksScreen.dart';
import 'package:todo/shared/components.dart';

import '../models/database.dart';
import '../shared/globals.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int indexSelected = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  List<Widget> screenList = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen()
  ];
  bool isBottomSheetShown = false;
  IconData currentIcon = Icons.add;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectDB().then((value) {
      getTasks().then((value) {
        setState(() {
          tasks = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[300],
        onPressed: () {
          if (isBottomSheetShown) {
            Navigator.of(context).maybePop();
            isBottomSheetShown = false;
            setState(() {
              currentIcon = Icons.add;
              titleController.clear();
              dateController.clear();
              timeController.clear();
            });
          } else {
            scaffoldKey.currentState
                ?.showBottomSheet(
                  enableDrag: false,
                  elevation: 20.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40.0)),
                  ),
                  (context) => Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultFormField(
                            controller: titleController,
                            inputType: TextInputType.text,
                            validate: (String? value) {
                              if (value.toString().isEmpty) {
                                return 'Title mustn\'t be Empty';
                              }
                              return null;
                            },
                            label: 'Title',
                            prefixIcon: Icons.title,
                            autoFocus: false,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            controller: dateController,
                            inputType: TextInputType.none,
                            validate: (String? value) {
                              if (value.toString().isEmpty) {
                                return 'Date mustn\'t be Empty';
                              }
                              return null;
                            },
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-06-01'))
                                  .then((value) {
                                if (value != null) {
                                  dateController.text =
                                      DateFormat.yMMMMd().format(value);
                                }
                              });
                            },
                            label: 'Date',
                            prefixIcon: Icons.date_range,
                            autoFocus: false,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          defaultFormField(
                            autoFocus: false,
                            controller: timeController,
                            inputType: TextInputType.none,
                            validate: (String? value) {
                              if (value.toString().isEmpty) {
                                return 'Time mustn\'t be Empty';
                              }
                              return null;
                            },
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((value) {
                                if (value != null) {
                                  timeController.text =
                                      value.format(context).toString();
                                }
                              });
                            },
                            label: 'Time',
                            prefixIcon: Icons.timelapse,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          FloatingActionButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                insertRow(
                                        titleController.text,
                                        dateController.text,
                                        timeController.text,
                                        'false')
                                    .then((value) {
                                  titleController.clear();
                                  dateController.clear();
                                  timeController.clear();
                                  getTasks().then((value) {
                                    setState(() {
                                      tasks = value;
                                    });
                                  });
                                  FocusScope.of(context).unfocus();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          'Task added successfully!'),
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                  );
                                });
                              }
                            },
                            child: const Icon(Icons.done_outline_sharp),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .closed
                .then((value) {
              isBottomSheetShown = false;
              setState(() {
                currentIcon = Icons.add;
              });
            });
            isBottomSheetShown = true;
            setState(() {
              currentIcon = Icons.close;
            });
          }
        },
        child: Icon(currentIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            indexSelected = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        currentIndex: indexSelected,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archive'),
        ],
      ),
      body: ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context) => screenList[indexSelected],
          fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}