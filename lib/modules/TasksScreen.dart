import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:todo/shared/globals.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoCubit cubit = TodoCubit.get(context);
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context, state) {},
      builder: (context, state){
        List<Map> cubitTasks = cubit.allUnDoneTasks;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ConditionalBuilder(
            condition: cubitTasks.isNotEmpty,
            builder: (context) => ListView.separated(
              itemBuilder: (context,index) => ItemContainer(
                  id: cubitTasks[index]['id'],
                  title: cubitTasks[index]['title'],
                  cubit: cubit,
                  dateTime: "${cubitTasks[index]['date']} - ${cubitTasks[index]['time']}",
                  onPressDone: (){cubit.updateTask(id: cubitTasks[index]['id'], status: 'done');},
                  onPressArchive: (){cubit.updateTask(id: cubitTasks[index]['id'], status: 'archive');}
              ),
              separatorBuilder: (context,index) => const SizedBox(height: 15,),
              itemCount: cubitTasks.length,
            ),
            fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/tasks.png'),
                    width: 350,
                    height: 350,
                  ),
                  SizedBox(height: 15,),
                  Text(
                    'No Tasks Yet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
