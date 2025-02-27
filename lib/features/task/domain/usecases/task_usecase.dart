import 'package:fpdart/fpdart.dart';
import 'package:todo_me/core/errors/failurs.dart';
import 'package:todo_me/core/usecases/usecase.dart';
import 'package:todo_me/features/task/domain/entities/todo_task.dart';
import 'package:todo_me/features/task/domain/repositories/todotask_repository.dart';

class CreateTodoTaskUseCase extends UseCase<TodoTask, TodoTask> {
  final TodoTaskRepository repository;
  CreateTodoTaskUseCase(this.repository);
  @override
  Future<Either<Failures, TodoTask>> call(TodoTask prams) async {
    // get data from repository
    var createTodoTask = await repository.createTodoTask(prams);
    return createTodoTask;
  }
}


class DeleteTodoTaskUseCase extends UseCase<bool, String> {
  final TodoTaskRepository repository;
  DeleteTodoTaskUseCase(this.repository);
  @override
  Future<Either<Failures, bool>> call(String prams) async {
    // get data from repository
    var deleteTodoTask = await repository.deleteTodoTask(prams);
    return deleteTodoTask.fold(
      (l) => Left(l), // if error return error as Failures
      (r) =>
          r
              ? Right(true) // if success return true
              : Left(
                CacheFailure(
                  'Failed to delete task',
                ), // else return CacheFailure
              ),
    );
  }}


class UpdateTodoTaskUseCase extends UseCase<TodoTask, TodoTask> {
  final TodoTaskRepository repository;
  UpdateTodoTaskUseCase(this.repository);
  @override
  Future<Either<Failures, TodoTask>> call(TodoTask prams) async {
    // get data from repository
    var updateTodoTask = await repository.updateTodoTask(prams);
    return updateTodoTask;
  }}


class ToggleTodoTaskUseCase extends UseCase<TodoTask, String> {
  final TodoTaskRepository repository;
  ToggleTodoTaskUseCase(this.repository);
  @override
  Future<Either<Failures, TodoTask>> call(String prams) async {
    // get data from repository
    var toggleTodoTask = await repository.toggleTodoTask(prams);
    return toggleTodoTask;
  }}




  class SyncTodoTasksDataUseCase extends UseCase<bool, NoParms> {
    final TodoTaskRepository repository;
    SyncTodoTasksDataUseCase(this.repository);
    @override
    Future<Either<Failures, bool>> call(NoParms prams) async {
     
      
      return repository.syncTasks();
    }
  }




