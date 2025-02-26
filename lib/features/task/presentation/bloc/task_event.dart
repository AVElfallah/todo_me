


import 'package:equatable/equatable.dart';

import '../../domain/entities/todo_task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}


class CreateTodoTaskEvent extends TaskEvent {
  final TodoTask todoTask;
  CreateTodoTaskEvent(this.todoTask);
}

class UpdateTodoTaskEvent extends TaskEvent {
  final TodoTask todoTask;
  UpdateTodoTaskEvent(this.todoTask);
}

class DeleteTodoTaskEvent extends TaskEvent {
  final String id;
  DeleteTodoTaskEvent(this.id);
}

class ToggleTodoTaskEvent extends TaskEvent {
  final String id;
  ToggleTodoTaskEvent(this.id);
}


