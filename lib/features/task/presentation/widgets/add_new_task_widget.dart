import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_me/features/task/domain/entities/todo_task.dart';
import 'package:todo_me/features/task/presentation/bloc/task_bloc.dart';
import 'package:todo_me/features/task/presentation/bloc/task_event.dart';

import '../../../../core/theme/app_colors.dart';

class AddNewTaskWidget extends StatefulWidget {
  const AddNewTaskWidget({
    super.key,
    this.height = 50,
  });

 
  final double? height;

  @override
  State<AddNewTaskWidget> createState() => _TaskNewLineWidgetState();
}

class _TaskNewLineWidgetState extends State<AddNewTaskWidget> {
  late final ValueNotifier<bool> _isCompleted;
  late final TextEditingController? controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _isCompleted = ValueNotifier( false);
    controller = TextEditingController(
    );
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    controller!.dispose();
    _isCompleted.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,

      child: TextFormField(
        focusNode: focusNode,
        //  readOnly: true,
        controller: controller,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:AppColors.mainTextColor),
        decoration: InputDecoration(
          prefixIcon:
               IconButton(
                    onPressed: () {
                      context.read<TodoTaskBloc>().add(
                        CreateTodoTaskEvent(
                          TodoTask(
                            id:
                                '${Random().nextInt(1000)}:${DateTime.now().millisecondsSinceEpoch}',
                            title: controller!.text,
                            isCompleted: false,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),

                          ),

                        ),
                      );
                      controller?.clear();
                      focusNode.unfocus();
                   
                    },
                    icon: Icon(Icons.add),
                  ),
          hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //  filled: true,
          //   fillColor: Colors.yellow,
          constraints: BoxConstraints(minHeight: 60, maxHeight: 60),

          hintText: "Add a new task",
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff8E88F1), width: 5),
          ),
        ),
      ),
    );
  }
}
