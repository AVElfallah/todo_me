import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_me/features/task/domain/repositories/todotask_repository.dart';


import 'task_event.dart';
import 'task_state.dart';

class TodoTaskBloc extends Bloc<TaskEvent, TaskState> {
  final TodoTaskRepository repository;
 

  TodoTaskBloc(this.repository) : super(TaskInitialState()) {
    on<CreateTodoTaskEvent>(_onCreateTodoTask);
    on<UpdateTodoTaskEvent>(_onUpdateTodoTask);
    on<DeleteTodoTaskEvent>(_onDeleteTodoTask);
    on<ToggleTodoTaskEvent>(_onToggleTodoTask);
  }



  Future<void> _onCreateTodoTask(CreateTodoTaskEvent event, Emitter<TaskState> emit) async {
    final result = await repository.createTodoTask(event.todoTask);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)), 
      (task) => emit(TaskCreatedState()),
    );
  }

  // تحديث مهمة
  Future<void> _onUpdateTodoTask(UpdateTodoTaskEvent event, Emitter<TaskState> emit) async {
    final result = await repository.updateTodoTask(event.todoTask);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)), 
      (Task) => emit(TaskUpdatedState()),
    );
  }

  // حذف مهمة
  Future<void> _onDeleteTodoTask(DeleteTodoTaskEvent event, Emitter<TaskState> emit) async {
    final result = await repository.deleteTodoTask(event.id);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)), 
      (task) => emit(TaskDeletedState()),
    );
  }

  // تغيير حالة المهمة
  Future<void> _onToggleTodoTask(ToggleTodoTaskEvent event, Emitter<TaskState> emit) async {
    final result = await repository.toggleTodoTask(event.id);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)),
      (task) => emit(TaskToggledState()),
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
