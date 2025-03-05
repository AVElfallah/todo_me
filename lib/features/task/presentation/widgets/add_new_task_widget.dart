import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_me/core/utils/validators.dart';
import 'package:todo_me/features/task/domain/entities/todo_task.dart';
import 'package:todo_me/features/task/presentation/bloc/task_bloc.dart';
import 'package:todo_me/features/task/presentation/bloc/task_event.dart';

import '../../../../core/theme/app_colors.dart';
// This widget allows users to add a new task to the task list.
class AddNewTaskWidget extends StatefulWidget {
  const AddNewTaskWidget({super.key, this.height = 50});

  final double? height;

  @override
  State<AddNewTaskWidget> createState() => _TaskNewLineWidgetState();
}

class _TaskNewLineWidgetState extends State<AddNewTaskWidget> {
  late final ValueNotifier<bool> _isCompleted;
  late final TextEditingController? controller;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    _isCompleted = ValueNotifier(false);
    formKey = GlobalKey<FormState>();
    controller = TextEditingController();
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
      child: Form(
        // Form widget to validate the input
        key: formKey,
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          // Automatically validate the input when the user interacts with the form
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // Validator for the text field input
          validator: (value) {
            return Validators.taskName(value).fold((l) => null, (r) => r);
          },
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor,
          ),
          decoration: InputDecoration(
            // Prefix icon button to add a new task
            prefixIcon: IconButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Dispatches an event to create a new task
                  context.read<TodoTaskBloc>().add(
                    CreateTodoTaskEvent(
                      TodoTask(
                        id: '${Random().nextInt(1000)}:${DateTime.now().millisecondsSinceEpoch}',
                        title: controller!.text,
                        isCompleted: false,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      ),
                    ),
                  );
                  // Clears the text field
                  controller?.clear();
                  // Unfocus the text field
                  focusNode.unfocus();
                  // Resets the form
                  formKey.currentState?.reset();
                }
              },
              icon: Icon(Icons.add),
            ),
            hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            constraints: BoxConstraints(minHeight: 60, maxHeight: 60),
            // Hint text for the text field
            hintText: "Add a new task",
            // Border for the text field
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff8E88F1), width: 5),
            ),
          ),
        ),
      ),
    );
  }
}
