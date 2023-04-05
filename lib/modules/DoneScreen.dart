
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../shared/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class DoneScreen extends StatelessWidget {
  const DoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodoCubit cubit = TodoCubit.get(context);
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> cubitTasks = cubit.allDoneTasks;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ConditionalBuilder(
            condition: cubitTasks.isNotEmpty,
            builder: (context) => ListView.separated(
              itemBuilder: (context,index) => ItemDoneContainer(
                id: cubitTasks[index]['id'],
                title: cubitTasks[index]['title'],
                dateTime: "${cubitTasks[index]['date']} - ${cubitTasks[index]['time']}",
                cubit: cubit
              ),
              separatorBuilder: (context,index) => const SizedBox(height: 15,),
              itemCount: cubitTasks.length,
            ),
            fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('assets/done.png'),
                    width: 350,
                    height: 350,
                  ),
                  SizedBox(height: 15,),
                  Text(
                    'No Done Tasks Yet',
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
