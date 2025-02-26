


import 'package:todo_me/features/task/data/models/todo_task_model.dart';

// Abstract class for a data source with a generic type T
abstract class TodoTaskDataSource<T> {
  final T source;

   Future<TodoTaskModel> createTodoTask(TodoTaskModel todoTask);
  Future<bool> deleteTodoTask(String id);
  Future<TodoTaskModel> updateTodoTask(TodoTaskModel todoTask);
  Future<TodoTaskModel> toggleTodoTask(String id);
  Stream<List<TodoTaskModel>> getTodoTasks();

  // Constructor to initialize the data source
  TodoTaskDataSource(this.source);
}

