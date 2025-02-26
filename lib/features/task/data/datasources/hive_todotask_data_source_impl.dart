import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:todo_me/features/task/data/datasources/todotask_data_source.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';

// Implementation of the TodotaskDataSource using Hive as the data source
class HiveTodotaskDataSourceImpl extends TodoTaskDataSource<HiveInterface> {
  // Constructor that takes a HiveInterface source
  HiveTodotaskDataSourceImpl(super.source);

  // Creates a new TodoTask and stores it in the Hive box
  @override
  Future<TodoTaskModel> createTodoTask(TodoTaskModel todoTask) async {
    final box=await source.openBox<TodoTaskModel>('tasks');
    box.put(todoTask.id, todoTask);
    
    return Future.value(todoTask);
  }

  // Deletes a TodoTask from the Hive box using the provided id
  @override
  Future<bool> deleteTodoTask(String id) async {
    final box=await source.openBox<TodoTaskModel>('tasks');
    box.delete(id);
    
    return Future.value(true);
  }

  // Returns a stream of the list of TodoTasks from the Hive box
  @override
  Stream<List<TodoTaskModel>> getTodoTasks()async* {
    final box=await source.openBox<TodoTaskModel>('tasks');
    // Get the Hive box containing TodoTaskModel objects
    
    
    // Create a StreamController to broadcast the list of TodoTaskModel objects
    final StreamController<List<TodoTaskModel>> _taskStreamController = StreamController.broadcast();
    
    // Listen for changes in the Hive box and update the stream with the new list of tasks
    box.watch().listen((_) {
      _taskStreamController.add(box.values.toList());
    });

    // Return the stream of TodoTaskModel lists
   yield* _taskStreamController.stream;


  }

  // Toggles the isCompleted status of a TodoTask and updates it in the Hive box
  @override
  Future<TodoTaskModel> toggleTodoTask(String id) async {
        final box=await source.openBox<TodoTaskModel>('tasks');

    // Retrieve the task from the Hive box using the provided id
    final task =box.get(id);
    
    // Create a new task object with the isCompleted field toggled
    final updatedTask = task?.copyWith(isCompleted: !task.isCompleted!);
    
    // Update the task in the Hive box with the new task object
    box.put(id, updatedTask!);

    
    
    // Return the updated task
    return Future.value(updatedTask);
  }

  // Updates an existing TodoTask in the Hive box
  @override
  Future<TodoTaskModel> updateTodoTask(TodoTaskModel todoTask) async {
            final box=await source.openBox<TodoTaskModel>('tasks');

    box.put(todoTask.id, todoTask);
    
    return Future.value(todoTask);
  }
}