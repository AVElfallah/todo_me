import 'package:flutter/material.dart';

class TaskNewLineWidget extends StatelessWidget {
  const TaskNewLineWidget({
    super.key,
    this.height = 50,
    this.isNewTask = true,
    this.controller,
  });
  final double? height;
  final bool? isNewTask;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,

      child: TextFormField(
        //  readOnly: true,
        controller: controller,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
readOnly: isNewTask! ? false : true,
        decoration: InputDecoration(
          prefixIcon:
              !isNewTask!
                  ? Checkbox(
                    value: false,

                    onChanged: (v) {
                      // TODO - check box handler
                    },
                    side: BorderSide(width: 2.5),
                  )
                  : IconButton(
                    onPressed: () {
                      // ToDo - add new task handler
                    },
                    icon: Icon(Icons.add),
                  ),
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //  filled: true,
          //   fillColor: Colors.yellow,
          constraints: BoxConstraints(minHeight: 60, maxHeight: 60),

          hintText: "test ",
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff8E88F1), width: 5),
          ),
        ),
      ),
    );
  }
}
