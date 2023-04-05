import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/shared/cubit/states.dart';

import '../../modules/ArchiveScreen.dart';
import '../../modules/DoneScreen.dart';
import '../../modules/TasksScreen.dart';

class TodoCubit extends Cubit<TodoStates>{
  TodoCubit() : super(InitialState());

  static TodoCubit get(context) => BlocProvider.of(context);

  int indexSelected = 0;
  List<Widget> screenList = [
    const TasksScreen(),
    const DoneScreen(),
    const ArchiveScreen()
  ];
  bool isBottomSheetShown = false;
  String todoTitle = 'Todo';
  Database? db;
  List<Map> allTasks = [];
  IconData currentIcon = Icons.add;
  List<Map> allUnDoneTasks = [];
  List<Map> allDoneTasks = [];
  List<Map> allArchiveTasks = [];

  void changeIndexNavigation(index){
    indexSelected = index;
    emit(BottomNavigationBarState());
    if(indexSelected == 0) {
      todoTitle = "Tasks";
    }
    else if(indexSelected == 1){
      todoTitle = "Done Tasks";
    }
    else{
      todoTitle = "Archived Tasks";
    }
  }

  void changeBottomSheet({required IconData icon,required bool isShown}){
    currentIcon = icon;
    isBottomSheetShown = isShown;
    emit(ChangeBottomSheetState());
  }

  void connectDB(){
    openDatabase(
      'todo2.db',
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          emit(CreateDBState());
        }).catchError((error) {
          print('error');
        });
      },
      onOpen: (db) {}
    ).then((value){
      db = value;
      emit(CreateDBState());
      getTasks();
    });
  }

  Future<void> insertRow(title, date, time, status) async {
    await db?.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time","$status")')
          .then((value) {
        emit(InsertTaskState());
        getTasks();
      }).catchError((error) {
        print(error);
      });
    });
    return;
  }

  void getTasks(){
    emit(GetDBLoadingState());
    db?.rawQuery('SELECT * FROM tasks').then((value){
      allTasks = value;
      allUnDoneTasks = [];
      allArchiveTasks = [];
      allDoneTasks = [];
      // print(allTasks);
      for (var element in value) {
        if(element['status'] == "false") {
          allUnDoneTasks.add(element);
        } else if(element['status'] == 'done') {
          allDoneTasks.add(element);
        } else {
          allArchiveTasks.add(element);
        }
      }
      emit(GetTasksState());
    });
  }

  void updateTask({required int id, required String status}) {
     db?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',[status,id]).then((value){
          getTasks();
          emit(UpdateTaskState());
     });
  }

  void DeleteTask({required int id}){
    db?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value){
      emit(DeleteTaskState());
      getTasks();
    });
  }

}