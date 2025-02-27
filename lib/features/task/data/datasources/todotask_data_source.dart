


import 'package:todo_me/features/task/data/models/deleted_todo_task_model.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';

// Abstract class for a data source with a generic type T
abstract class TodoTaskDataSource<T> {
 late final T source;

  Future<TodoTaskModel> createTodoTask(TodoTaskModel todoTask);
  Future<bool> deleteTodoTask(String id);
  Future<TodoTaskModel> updateTodoTask(TodoTaskModel todoTask);
  Future<TodoTaskModel> toggleTodoTask(String id);
  Future<(List<TodoTaskModel>?,DateTime?)> getAllTodoTasks();
  Future<List<DeletedTodoTaskModel>> getDeletedTasks();
  Future<bool> syncAndUpdateCurrentData(List<TodoTaskModel> data,DateTime lastDataUpdate, List<DeletedTodoTaskModel> deletedTasks);

  // Constructor to initialize the data source
  TodoTaskDataSource(this.source);
}

