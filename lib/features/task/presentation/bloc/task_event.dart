


import 'package:equatable/equatable.dart';
import 'package:todo_me/features/task/presentation/bloc/task_state.dart';

import '../../domain/entities/todo_task.dart';

abstract class TaskEvent extends Equatable {

  final Function(TaskState)? onCompleted;
  const TaskEvent(this.onCompleted);

  @override
  List<Object> get props => [];
}

class SyncTodoTaskEvent extends TaskEvent {
  SyncTodoTaskEvent({Function(TaskState)? onCompleted}):super(onCompleted);
}

class CreateTodoTaskEvent extends TaskEvent {
  final TodoTask todoTask;
  CreateTodoTaskEvent(this.todoTask,{Function(TaskState)? onCompleted}):super(onCompleted);
}

class UpdateTodoTaskEvent extends TaskEvent {
  final TodoTask todoTask;
  UpdateTodoTaskEvent(this.todoTask,{Function(TaskState)? onCompleted}):super(onCompleted);
}

class DeleteTodoTaskEvent extends TaskEvent {
  final String id;
  DeleteTodoTaskEvent(this.id,{Function(TaskState)? onCompleted}):super(onCompleted);
}

class ToggleTodoTaskEvent extends TaskEvent {
  final String id;
  ToggleTodoTaskEvent(this.id,{Function(TaskState)? onCompleted}):super(onCompleted);
}


