import 'package:fpdart/fpdart.dart';
import 'package:todo_me/features/task/domain/entities/todo_task.dart';

import '../../../../core/errors/failurs.dart';

abstract class TodoTaskRepository {
  Future<Either<Failures,TodoTask>> createTodoTask(TodoTask todoTask);
  Future<Either<Failures,bool>> deleteTodoTask(String id);
  Future<Either<Failures,TodoTask>> updateTodoTask(TodoTask todoTask);
  Future<Either<Failures,TodoTask>> toggleTodoTask(String id);
  Stream<Either<Failures,List<TodoTask>>> getTodoTasks();

  // test features
  Stream<Either<Failures,List<TodoTask>>> getOfflineTodoTasks();
  Stream<Either<Failures,List<TodoTask>>> getOnlineTodoTasks();
}