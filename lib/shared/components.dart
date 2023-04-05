import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType inputType,
  Function(String?)? onSubmit,
  Function(String?)? onChange,
  Function()? onTap,
  required String? Function(String?) validate,
  bool obscure = false,
  required String label,
  required IconData prefixIcon,
  IconData? suffixIcon,
  bool isClickable = true,
  bool autoFocus = true,
})=> TextFormField(
  controller: controller,
  autofocus: autoFocus,
  keyboardType: inputType,
  onFieldSubmitted: onSubmit,
  onChanged: onChange,
  obscureText: obscure,
  validator: validate,
  onTap: onTap,
  enabled: isClickable,
  decoration: InputDecoration(
    labelText: label,
    prefix: Icon(prefixIcon),
    suffixIcon: Icon(suffixIcon),
    border: const OutlineInputBorder(),
    floatingLabelAlignment: FloatingLabelAlignment.center,
  ),
);


Widget ItemContainer({
  required int id,
  required String title,
  required String dateTime,
  required void Function()? onPressDone,
  required void Function()? onPressArchive,
  required TodoCubit cubit,
})=> Dismissible(
  key: Key(id.toString()),
  onDismissed: (direction) {
    cubit.DeleteTask(id: id);
  },
  child:   Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.deepPurple,
            ),
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Expanded(
                        child: Text(
                          dateTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: onPressDone,
                        icon: const Icon(Icons.check_box,color: Colors.white),
                      ),
                      IconButton(
                        onPressed: onPressArchive,
                        icon: const Icon(Icons.archive,color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);

Widget ItemDoneContainer({
  required int id,
  required String title,
  required String dateTime,
  required TodoCubit cubit,
})=> Dismissible(
  key: Key(id.toString()),
  onDismissed: (direction) {
    cubit.DeleteTask(id: id);
  },
  child:   Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.deepPurple,
            ),
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 3,),
                      Expanded(
                        child: Text(
                          dateTime,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);