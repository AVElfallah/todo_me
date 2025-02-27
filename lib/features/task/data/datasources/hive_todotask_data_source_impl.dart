import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:todo_me/features/task/data/datasources/todotask_data_source.dart';
import 'package:todo_me/features/task/data/models/deleted_todo_task_model.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';

// Implementation of the TodotaskDataSource using Hive as the data source
class HiveTodotaskDataSourceImpl extends TodoTaskDataSource<HiveInterface> {
  // Constructor that takes a HiveInterface source
  HiveTodotaskDataSourceImpl(super.source);

  // Creates a new TodoTask and stores it in the Hive box
  @override
  Future<TodoTaskModel> createTodoTask(TodoTaskModel todoTask) async {
    // open tasks box
    final box = await source.openBox<TodoTaskModel>('tasks');
    // open deletedTasks box
    final lastDataUpdateBox = await source.openBox<DateTime>('lastDataUpdate');
    // add the new task to the box
    box.put(todoTask.id, todoTask);
    // set lastDataUpdate to the current timestamp
    lastDataUpdateBox.put('lastDataUpdate', Timestamp.now().toDate());

    return Future.value(todoTask);
  }

  // Deletes a TodoTask from the Hive box using the provided id
  @override
  Future<bool> deleteTodoTask(String id) async {
    // open tasks box
    final box = await source.openBox<TodoTaskModel>('tasks');
    // open deletedTasks box
    final deletedTasksBox = await source.openBox<DeletedTodoTaskModel>(
      'deletedTasks',
    );
    // open lastDataUpdate box
    final lastDataUpdateBox = await source.openBox<DateTime>('lastDataUpdate');
    // delete the task from the box
    box.delete(id);
    // add the deleted task to the deletedTasks box
    deletedTasksBox.put(
      id,
      DeletedTodoTaskModel(id: id, deletedTime: Timestamp.now().toDate()),
    );
    // set lastDataUpdate to the current timestamp
    lastDataUpdateBox.put('lastDataUpdate', Timestamp.now().toDate());

    return Future.value(true);
  }

  // Toggles the isCompleted status of a TodoTask and updates it in the Hive box
  @override
  Future<TodoTaskModel> toggleTodoTask(String id) async {
    // open tasks box
    final box = await source.openBox<TodoTaskModel>('tasks');
    // open lastDataUpdate box
    final lastDataUpdateBox = await source.openBox<DateTime>('lastDataUpdate');

    // Retrieve the task from the Hive box using the provided id
    final task = box.get(id);

    // Create a new task object with the isCompleted field toggled
    final updatedTask = task?.copyWith(isCompleted: !task.isCompleted!);

    // Update the task in the Hive box with the new task object
    box.put(id, updatedTask!);

    // update last update date
    lastDataUpdateBox.put('lastDataUpdate', Timestamp.now().toDate());

    // Return the updated task
    return Future.value(updatedTask);
  }

  // Updates an existing TodoTask in the Hive box
  @override
  Future<TodoTaskModel> updateTodoTask(TodoTaskModel todoTask) async {
    // open tasks box
    final box = await source.openBox<TodoTaskModel>('tasks');
    // open lastDataUpdate box
    final lastDataUpdateBox = await source.openBox<DateTime>('lastDataUpdate');

    // Update the task in the Hive box with the new task object
    box.put(todoTask.id, todoTask);
    // update last update date
    lastDataUpdateBox.put('lastDataUpdate', Timestamp.now().toDate());

    return Future.value(todoTask);
  }

  @override
  Future<(List<TodoTaskModel>?, DateTime?)> getAllTodoTasks() async {
    // open tasks box
    final box = await source.openBox<TodoTaskModel>('tasks');
    // open lastDataUpdate box
    final lastDataUpdateBox = await source.openBox<DateTime>('lastDataUpdate');
    // get all tasks from the box
    final tasks = box.values.toList();
    // get last update date
    final lastDataUpdate = lastDataUpdateBox.get('lastDataUpdate');
    return Future.value((tasks, lastDataUpdate));
  }

  @override
  Future<List<DeletedTodoTaskModel>> getDeletedTasks() async {
    // open deletedTasks box
    final box = await source.openBox<DeletedTodoTaskModel>('deletedTasks');
    // get all deleted tasks from the box
    final deletedTasks = box.values.toList();
    return Future.value(deletedTasks);
  }

  @override
  Future<bool> syncAndUpdateCurrentData(
    List<TodoTaskModel>? onlineData,
    DateTime? OnlineLastDataUpdate,
    List<DeletedTodoTaskModel>? onlineDeletedTasks,
  ) async {
    // open tasks box
    try {
      final box = await source.openBox<TodoTaskModel>('tasks');
      // open deletedTasks box
      final deletedTasksBox = await source.openBox<DeletedTodoTaskModel>(
        'deletedTasks',
      );
      // open lastDataUpdate box
      final lastDataUpdateBox = await source.openBox<DateTime>(
        'lastDataUpdate',
      );

      //SECTION[Start] - Deleted Tasks Section
      //checking if the online deleted tasks are the same as the offline deleted tasks
      if ((onlineDeletedTasks ?? [])
              .toList()
              .takeWhile((dTask) => deletedTasksBox.containsKey(dTask.id))
              .length ==
          deletedTasksBox.length) {
        //if they are the same, delete all the offline deleted tasks
        deletedTasksBox.clear();
      } else {
        // check and delete from offline data
        for (var dTask in onlineDeletedTasks ?? []) {
          // delete from offline data
          if (deletedTasksBox.containsKey(dTask.id)) {
            deletedTasksBox.delete(dTask.id);
          }
          // empty the deletedTasks box
          deletedTasksBox.clear();
        }
      }

      //SECTION[End] - Deleted Tasks Section

      //SECTION[Start] - Tasks Section
      // if the online data is newer than the offline data, update the offline data
      if ((OnlineLastDataUpdate?.isAfter(
            lastDataUpdateBox.get('lastDataUpdate')??DateTime(1999),
          ) ??
          onlineData != null)) {
        //update the offline data with the online data
        for (var oTask in onlineData ?? <TodoTaskModel>[]) {
          // check if the task is already in the offline data
          if (box.containsKey(oTask.id)) {
            // check if the online task is newer than the offline task
            if (oTask.createdAt?.isAfter(
                  box.get(oTask.id)?.updatedAt ?? DateTime(1999),
                ) ??
                false) {
              // update the offline task
              box.put(oTask.id, oTask);
            }
          } else {
            box.put(oTask.id, oTask);
          }
        }

        //SECTION[End] - Tasks Section
      }
      lastDataUpdateBox.put('lastDataUpdate', Timestamp.now().toDate());
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }
}
