import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_me/features/task/data/models/deleted_todo_task_model.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';

import 'todotask_data_source.dart';

class FirebaseTodotaskDataSourceImpl
    extends TodoTaskDataSource<FirebaseFirestore> {
  FirebaseTodotaskDataSourceImpl(super.source);

  @override
  Future<TodoTaskModel> createTodoTask(TodoTaskModel todoTask) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await source.collection('users').doc(currentUser);
    // Add the new task to the user's collection
    await userDoc
        .collection('tasks')
        .doc('${todoTask.id}')
        .set(todoTask.toJson());
    // set lastDataUpdate to the current timestamp
    await userDoc.set({'lastDataUpdate': Timestamp.now()});
    return todoTask;
  }

  @override
  Future<bool> deleteTodoTask(String id) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await source.collection('users').doc(currentUser);

    // Delete the task from the user's collection
    await userDoc.collection('tasks').doc(id).delete();
    // Add the deleted task to the user's deletedTasks collection
    await userDoc
        .collection('deletedTasks')
        .doc(id)
        .set(
          DeletedTodoTaskModel(id: id, deletedTime: DateTime.now()).toJson(),
        );

    // set lastDataUpdate to the current timestamp
    await userDoc.set({'lastDataUpdate': Timestamp.now()});

    return true;
  }

  @override
  Future<(List<TodoTaskModel>, DateTime)> getAllTodoTasks() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    // user document
    final userDoc = await source.collection('users').doc(currentUser);

    // Get all tasks from the user's collection
    var snapshots = await userDoc.collection('tasks').get();
    // Get the lastDataUpdate timestamp from the user's document
    final lastDataUpdate =
        ((await userDoc.get()).data()?['lastDataUpdate'] ??
                Timestamp.fromDate(DateTime(1990)))
            as Timestamp;
    // Return the tasks and the lastDataUpdate timestamp
    return (
      snapshots.docs.map((doc) => TodoTaskModel.fromJson(doc.data())).toList(),
      lastDataUpdate.toDate(),
    );
  }

  @override
  Future<TodoTaskModel> toggleTodoTask(String id) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await source.collection('users').doc(currentUser);

    // Get the task from the user's collection
    final task = await userDoc.collection('tasks').doc(id).get();
    final taskData = task.data() ?? {};
    // Toggle the task's completion status
    final updatedTask = TodoTaskModel.fromJson(
      taskData,
    ).copyWith(isCompleted: !taskData['isCompleted']??false, updatedAt: DateTime.now());
    // Update the task in the user's collection
    await userDoc.collection('tasks').doc(id).update(updatedTask.toJson());

    // lastDataUpdate to the current timestamp
    await userDoc.set({'lastDataUpdate': Timestamp.now()});

    return updatedTask;
  }

  @override
  Future<TodoTaskModel> updateTodoTask(TodoTaskModel todoTask) async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    // user document
    final userDoc = await source.collection('users').doc(currentUser);

    // Update the task in the user's collection
    await userDoc
        .collection('tasks')
        .doc(todoTask.id)
        .update(todoTask.copyWith(updatedAt: DateTime.now()).toJson());

    // lastDataUpdate to the current timestamp
    await userDoc.set({'lastDataUpdate': Timestamp.now()});

    return todoTask;
  }

  //be aware of that our base data model is the offline data
  @override
  Future<bool> syncAndUpdateCurrentData(
    List<TodoTaskModel>? offlineData,
    DateTime? offlineLastDataUpdate,
    List<DeletedTodoTaskModel>? offlineDeletedTasks,
  ) async {
    //get user id
    try {
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      //user document
      final userDoc = await source.collection('users').doc(currentUser);
      // get online data
      final onlineData = await userDoc.collection('tasks').get();
      // get last update data
      final onlineLastDataUpdate =
          (await userDoc.get()).data()?['lastDataUpdate'] as Timestamp?;
      // get deleted tasks
      final onlineDeletedTasksData =
          await userDoc.collection('deletedTasks').get();

      //SECTION[Start] - Deleted Tasks Section
      // check if deleted tasks are the same as the online deleted tasks
      if (
      // make comparison between the deleted tasks and the online deleted tasks
      // and make sure that the deleted tasks are the same as the online deleted tasks
      (onlineDeletedTasksData.docs
              .takeWhile(
                (element) =>
                    offlineDeletedTasks?.any((e) => e.id == element.id) ??
                    false,
              )
              .length) ==
          (offlineDeletedTasks?.length ?? 0)) {
        // empty the deleted tasks collection
        var deletedTaskRef = await userDoc.collection('deletedTasks').get();
        for (final doc in deletedTaskRef.docs) {
          await doc.reference.delete();
        }
      } else {
        //check and delete from  online data using the deleted tasks
        for (var deletedTask in (offlineDeletedTasks ?? [])) {
          // remove the deleted task from the online data
          await userDoc.collection('tasks').doc(deletedTask.id).delete();
        }
        // delete the deleted task from the deletedTasks collection
        await userDoc
            .collection('deletedTasks')
            .doc(onlineDeletedTasksData.docs.first.id)
            .delete();
      }
      //SECTION[End] - Deleted Tasks Section

      //SECTION[Start] - Updated Tasks Section
      // if the offline data is newer than the online data
      if ((offlineLastDataUpdate?.isAfter(
            onlineLastDataUpdate?.toDate() ?? DateTime(1999),
          ) ??
          offlineData != null)) {
        // update the online data with the offline data
        for (var offlineTask in offlineData ?? <TodoTaskModel>[]) {
          // check if the offline task is in the online data
          if (onlineData.docs.any((element) => element.id == offlineTask.id)) {
            // update the online task with the offline task
            final task = await userDoc.collection('tasks').doc(offlineTask.id);
            
            //check if the online task is newer than the offline task
            var lastUp = (await task.get()) ['updatedAt']?? DateTime(1999);
            if (
              
              (lastUp as Timestamp)
                .toDate()
                .isAfter(offlineTask.updatedAt ?? DateTime(1999))) {
              continue;
            } else if (!onlineData.docs.any(
              (element) => element.id == offlineTask.id,
            )) {
              task.update(offlineTask.toJson());
            } else {
              // update the online task with the offline task
              // if the offline task is newer than the online task
              task.update(offlineTask.toJson());
            }

            //task .update(offlineTask.toJson());
          } else {
            // add the offline task to the online data
            await userDoc
                .collection('tasks')
                .doc(offlineTask.id)
                .set(offlineTask.toJson());
          }
        }
      } else {
        await userDoc.set({'lastDataUpdate': Timestamp.now()});

        return true;
      }

      //SECTION[End] - Updated Tasks Section

      // update lastDataUpdate to the current timestamp
      await userDoc.set({'lastDataUpdate': Timestamp.now()});

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<DeletedTodoTaskModel>> getDeletedTasks() async {
    try {
      final currentUser = await FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await source.collection('users').doc(currentUser);
      final deletedTasks = await userDoc.collection('deletedTasks').get();
      return deletedTasks.docs
          .map((e) => DeletedTodoTaskModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }
}
