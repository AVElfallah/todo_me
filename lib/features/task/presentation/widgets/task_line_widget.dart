import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_me/core/theme/app_colors.dart';
import 'package:todo_me/features/task/presentation/bloc/task_event.dart';

import '../../domain/entities/todo_task.dart';
import '../bloc/task_bloc.dart';

class TaskLineWidget extends StatefulWidget {
  const TaskLineWidget({super.key, this.todoTask, this.height = 50});
  final TodoTask? todoTask;
  final double? height;

  @override
  State<TaskLineWidget> createState() => _TaskLineWidgetState();
}

class _TaskLineWidgetState extends State<TaskLineWidget> {
  late final ValueNotifier<bool> _isOpenToEdit, _isCompleted;
  late final TextEditingController controller;
  final GlobalKey _textFieldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isCompleted = ValueNotifier(widget.todoTask?.isCompleted ?? false);
    _isOpenToEdit = ValueNotifier(false);
    controller = TextEditingController(text: widget.todoTask?.title);
  }

  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,

      child: ValueListenableBuilder(
        valueListenable: _isOpenToEdit,
        builder:
            (_, isOpen, _) => ValueListenableBuilder(
              valueListenable: _isCompleted,
              builder:
                  (_, isCompleted, _) => GestureDetector(
                    onLongPress: () {
                      _isOpenToEdit.value = !_isOpenToEdit.value;
                    },
                    child: TextFormField(
                      key: _textFieldKey,
                      controller: controller,
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value!.isEmpty ? "Task can't be empty" : null,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration:
                            isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                        decorationThickness: 1.5,
                        decorationColor: Colors.grey,
                        color:
                            isCompleted
                                ? AppColors.secondaryTextColor
                                : AppColors.mainTextColor,
                      ),
                    
                      readOnly: !isOpen ,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                details.globalPosition.dx, // X-axis
                                details.globalPosition.dy, // Y-axis
                                details.globalPosition.dx +
                                    10, // Right padding
                                details.globalPosition.dy +
                                    40, // Bottom padding
                              ),
                              items: [
                                PopupMenuItem(
                                  value: "Edit",
                                  child: Text("Edit"),
                                  onTap: (){
                                    _isOpenToEdit.value = !_isOpenToEdit.value;
                                  },
                                ),
                                PopupMenuItem(
                                  value: "Delete",
                                  child: Text("Delete"),
                                  onTap: (){
                                    context.read<TodoTaskBloc>().add(
                                      DeleteTodoTaskEvent(
                                        widget.todoTask!.id!,
                                      ),
                                    );
                                  }
                                ),
                              ],
                            );
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: AppColors.mainTextColor,
                          ),
                        ),
                        prefixIcon: Checkbox(
                          value: isCompleted,
                    
                          onChanged: (v) {
                            // to toggle the task completion status
                            _isCompleted.value = v!;
                            // call the bloc to update the task status
                            context.read<TodoTaskBloc>().add(
                              ToggleTodoTaskEvent(widget.todoTask!.id!),
                            );
                          },
                          side: BorderSide(width: 2.5),
                        ),
                    
                        suffix:
                            isOpen
                                ? IconButton(
                                  onPressed: () {
                                    _isOpenToEdit.value = !_isOpenToEdit.value;
                                    BlocProvider.of<TodoTaskBloc>(context).add(
                                      UpdateTodoTaskEvent(
                                        widget.todoTask!.copyWith(
                                          title: controller.text,
                                          isCompleted: isCompleted,
                                          updatedAt: DateTime.now(),
                                        )
                                      ),
                                    );
                                    
                                  },
                                  icon: Icon(Icons.save),
                                )
                                : null,
                    
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        constraints: BoxConstraints(
                          minHeight: 60,
                          maxHeight: 60,
                        ),
                    
                        hintText: "Update your task",
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff8E88F1),
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
      ),
    );
  }
}
