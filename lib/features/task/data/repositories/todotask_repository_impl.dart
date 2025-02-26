import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:todo_me/core/errors/failurs.dart';
import 'package:todo_me/features/task/data/datasources/todotask_data_source.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';
import 'package:todo_me/features/task/domain/entities/todo_task.dart';
import 'package:todo_me/features/task/domain/repositories/todotask_repository.dart';

class TodotaskRepositoryImpl extends TodoTaskRepository {
  final TodoTaskDataSource _onlineDataSource;
  final TodoTaskDataSource _offlineDataSource;

  TodotaskRepositoryImpl(this._onlineDataSource, this._offlineDataSource);
@override
Stream<Either<Failures, List<TodoTask>>> getTodoTasks() async* {
  final controller = StreamController<Either<Failures, List<TodoTask>>>.broadcast();
  StreamSubscription<List<TodoTaskModel>>? subscription;

  try {
    Stream<List<TodoTaskModel>> stream;

    if ((await InternetConnection().internetStatus) == InternetStatus.connected) {
      stream = _onlineDataSource.getTodoTasks();
    } else {
      stream = _offlineDataSource.getTodoTasks();
    }

    subscription = stream.listen(
      (data) {
        final tasks = data.map((model) => model.toEntity()).toList();
        controller.add(Right(tasks)); // Emit the updated tasks list
      },
      onError: (error) {
        controller.add(Left(ServerFailure(error.toString())));
      },
    );

    yield* controller.stream;
  } finally {
    // Cleanup when the stream is closed
    await subscription?.cancel();
    await controller.close();
  }
}


  @override
  Future<Either<Failures, TodoTask>> createTodoTask(TodoTask todoTask) async {
    try {
      var fromEntity = TodoTaskModel.fromEntity(todoTask);
      final offlineResult = await _offlineDataSource.createTodoTask(fromEntity);
      if (await InternetConnection().hasInternetAccess) {
        return Right(await _onlineDataSource.createTodoTask(fromEntity));
      } else {
        return Right(offlineResult);
      }
    } on CacheFailure catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failures, bool>> deleteTodoTask(String id) async {
    try {
      final offlineResult = await _offlineDataSource.deleteTodoTask(id);
      if (await InternetConnection().hasInternetAccess) {
        return Right(await _onlineDataSource.deleteTodoTask(id));
      } else {
        return Right(offlineResult);
      }
    } on CacheFailure catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failures, TodoTask>> toggleTodoTask(String id) async {
    try {
      final offlineResult = await _offlineDataSource.toggleTodoTask(id);
      if (await InternetConnection().hasInternetAccess) {
        return Right(await _onlineDataSource.toggleTodoTask(id));
      } else {
        return Right(offlineResult);
      }
    } on CacheFailure catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failures, TodoTask>> updateTodoTask(TodoTask todoTask) async {
    try {
      var fromEntity = TodoTaskModel.fromEntity(todoTask);
      final offlineResult = await _offlineDataSource.updateTodoTask(fromEntity);
      if (await InternetConnection().hasInternetAccess) {
        return Right(await _onlineDataSource.updateTodoTask(fromEntity));
      } else {
        return Right(offlineResult);
      }
    } on CacheFailure catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
  
  @override
  Stream<Either<Failures, List<TodoTask>>> getOfflineTodoTasks()async* {
  try{
   await for (var result in _offlineDataSource.getTodoTasks()){
    yield Right(result.map((model) => model.toEntity()).toList());
  }
   
   }
   catch(e){
    yield Left(CacheFailure(e.toString()));
  }
  }
  
  @override
  Stream<Either<Failures, List<TodoTask>>> getOnlineTodoTasks()async* {
    try{
  await for (var result in _onlineDataSource.getTodoTasks()){
    yield Right(result.map((model) => model.toEntity()).toList());
  }}
   catch(e){
    yield Left(ServerFailure(e.toString()));
  }}
}
