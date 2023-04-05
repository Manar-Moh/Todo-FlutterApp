import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/modules/ArchiveScreen.dart';
import 'package:todo/modules/DoneScreen.dart';
import 'package:todo/modules/TasksScreen.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

import '../models/database.dart';
import '../shared/globals.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TodoCubit()..connectDB(),
      child: BlocConsumer<TodoCubit, TodoStates>(
        listener: (context, state) {
          if(state is InsertTaskState){
            titleController.clear();
            dateController.clear();
            timeController.clear();
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
          }
          print(state);
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.todoTitle),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.deepPurple[300],
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  Navigator.of(context).maybePop();
                  cubit.changeBottomSheet(icon: Icons.add, isShown: false);
                } else {
                  cubit.changeBottomSheet(icon: Icons.edit, isShown: true);
                  scaffoldKey.currentState?.showBottomSheet(
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
                                    if (value
                                        .toString()
                                        .isEmpty) {
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
                                    if (value
                                        .toString()
                                        .isEmpty) {
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
                                    if (value
                                        .toString()
                                        .isEmpty) {
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
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.insertRow(titleController.text,dateController.text,timeController.text,'false');
                                    }
                                  },
                                  child: const Icon(Icons.done_outline_sharp),
                                ),
                              ],
                            ),
                          ),
                        ),
                  ).closed.then((value) {
                    cubit.changeBottomSheet(icon: Icons.add, isShown: false);
                  });
                }
              },
              child: Icon(cubit.currentIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeIndexNavigation(index);
              },
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.indexSelected,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! GetDBLoadingState ,
              builder: (context) => cubit.screenList[cubit.indexSelected],
              fallback: (context) => const Center(child: CircularProgressIndicator()),
            ),
          );
        }
      ),
    );
  }
}
