import 'package:flutter/material.dart';

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
  required String title,
  required String dateTime,
})=> Padding(
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
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
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
                    Text(
                      dateTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   width: 40,
                //   child: FloatingActionButton(
                //       onPressed: (){},
                //       backgroundColor: Colors.white,
                //       child: const Icon(Icons.done,size: 20,color: Colors.deepPurple,),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);