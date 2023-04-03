import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  void changeIndexNavigation(index){
    indexSelected = index;
    emit(BottomNavigationBarState());
  }

}