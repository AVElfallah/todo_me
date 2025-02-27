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
  Future<Either<Failures, bool>> syncTasks() async {
    // we consider the offline data source as the source of truth
    // so we need to sync the online data source with the offline data source
    // we can do this by getting the data from the offline data source and sync it with the online data source
    try {
      // get data from offline data source
      final (offlineTasks, offlineLastDataUpdate) =
          await _offlineDataSource.getAllTodoTasks();

      // get data from online data source
      final (onlineTasks, onlineLastDataUpdate) =
          await _onlineDataSource.getAllTodoTasks();

      // get deleted tasks from offline and online data sources
      final offlineDeleteTasks = await _offlineDataSource.getDeletedTasks();
      final onlineDeleteTasks = await _onlineDataSource.getDeletedTasks();

      // sync offline data with online data
      final isOfflineDone = await _offlineDataSource.syncAndUpdateCurrentData(
        onlineTasks ?? [],
        onlineLastDataUpdate ?? DateTime.now(),
        offlineDeleteTasks,
      );
      // sync online data with offline data
      final isOnlineDone = await _onlineDataSource.syncAndUpdateCurrentData(
        offlineTasks ?? [],
        offlineLastDataUpdate ?? DateTime.now(),
        onlineDeleteTasks,
      );

      return Right(isOfflineDone && isOnlineDone);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
