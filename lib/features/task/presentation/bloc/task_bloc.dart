import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_me/core/usecases/usecase.dart';

import '../../domain/usecases/task_usecase.dart';
import 'task_event.dart';
import 'task_state.dart';

class TodoTaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetIt locator;

  TodoTaskBloc(this.locator) : super(TaskInitialState()) {
    on<SyncTodoTaskEvent>(_onSyncTodoTask);
    on<CreateTodoTaskEvent>(_onCreateTodoTask);
    on<UpdateTodoTaskEvent>(_onUpdateTodoTask);
    on<DeleteTodoTaskEvent>(_onDeleteTodoTask);
    on<ToggleTodoTaskEvent>(_onToggleTodoTask);
  }
  Future<void> _onSyncTodoTask(
    SyncTodoTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final syncTaskUsecase = locator<SyncTodoTasksDataUseCase>();
    final result = await syncTaskUsecase.call(NoParms());
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)),
      (isSynced) => emit(isSynced ? TaskSuccessfullySyncedState() : TaskFailureSyncedState()),
    );
  }

  Future<void> _onCreateTodoTask(
    CreateTodoTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final createTaskUsecase = locator<CreateTodoTaskUseCase>();

    final result = await createTaskUsecase.call(event.todoTask);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)),
      (task) => emit(TaskCreatedState()),
    );
  }

  // تحديث مهمة
  Future<void> _onUpdateTodoTask(
    UpdateTodoTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final updateTaskUsecase = locator<UpdateTodoTaskUseCase>();
    final result = await updateTaskUsecase.call(event.todoTask);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)),
      (Task) => emit(TaskUpdatedState()),
    );
  }

  // حذف مهمة
  Future<void> _onDeleteTodoTask(
    DeleteTodoTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final deleteTaskUsecase = locator<DeleteTodoTaskUseCase>();
    final result = await deleteTaskUsecase.call(event.id);
    result.fold(
      (failure) => emit(TodoTaskErrorState(failure.message)),
      (task) => emit(TaskDeletedState()),
    );
  }

  // تغيير حالة المهمة
  Future<void> _onToggleTodoTask(
    ToggleTodoTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    final toggleTaskUsecase = locator<ToggleTodoTaskUseCase>();
    final result = await toggleTaskUsecase.call(event.id);
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
