import 'package:fpdart/fpdart.dart';
import 'package:todo_me/features/task/domain/entities/todo_task.dart';

import '../../../../core/errors/failurs.dart';

abstract class TodoTaskRepository {
  Future<Either<Failures,TodoTask>> createTodoTask(TodoTask todoTask);
  Future<Either<Failures,bool>> deleteTodoTask(String id);
  Future<Either<Failures,TodoTask>> updateTodoTask(TodoTask todoTask);
  Future<Either<Failures,TodoTask>> toggleTodoTask(String id);

  @Deprecated('this function replaced')
  Stream<Either<Failures,List<TodoTask>>> getTodoTasks();



  // new solution for sync data
  Future<Either<Failures,bool>> syncTasks();
}