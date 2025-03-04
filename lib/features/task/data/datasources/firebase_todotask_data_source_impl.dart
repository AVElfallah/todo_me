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
    ).copyWith(isCompleted: !taskData['isCompleted'], updatedAt: DateTime.now());
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
  try {
    // الحصول على معرف المستخدم الحالي
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    // مرجع لمستند المستخدم في قاعدة البيانات
    final userDoc = await source.collection('users').doc(currentUser);

    // جلب البيانات الحالية (المهام)
    final onlineData = await userDoc.collection('tasks').get();

    // جلب تاريخ آخر تحديث للبيانات من السيرفر
    final onlineLastDataUpdate =
        (await userDoc.get()).data()?['lastDataUpdate'] as Timestamp?;

    // جلب قائمة المهام المحذوفة من السيرفر
    final onlineDeletedTasksData =
        await userDoc.collection('deletedTasks').get();

    // ------------------ [حذف المهام المحذوفة] ------------------ //

    // التحقق مما إذا كانت قائمة المهام المحذوفة محليًا متطابقة مع المخزنة على السيرفر
    final bool isDeletedTasksSame = (onlineDeletedTasksData.docs
            .takeWhile(
              (element) =>
                  offlineDeletedTasks?.any((e) => e.id == element.id) ?? false,
            )
            .length) ==
        (offlineDeletedTasks?.length ?? 0);

    if (isDeletedTasksSame) {
      // تفريغ قائمة المهام المحذوفة على السيرفر
      var deletedTaskRef = await userDoc.collection('deletedTasks').get();
      for (final doc in deletedTaskRef.docs) {
        await doc.reference.delete();
      }
    } else {
      // حذف المهام المحذوفة محليًا من السيرفر
      for (var deletedTask in (offlineDeletedTasks ?? [])) {
        await userDoc.collection('tasks').doc(deletedTask.id).delete();
      }

      // حذف المهمة المحذوفة من مجموعة deletedTasks
      if (onlineDeletedTasksData.docs.isNotEmpty) {
        await userDoc
            .collection('deletedTasks')
            .doc(onlineDeletedTasksData.docs.first.id)
            .delete();
      }
    }

    // ------------------ [تحديث البيانات] ------------------ //

    // التحقق مما إذا كانت البيانات المحلية أحدث من البيانات الموجودة على السيرفر
    final bool isOfflineDataNewer = offlineLastDataUpdate?.isAfter(
          onlineLastDataUpdate?.toDate() ?? DateTime(1999),
        ) ??
        offlineData != null;

    if (isOfflineDataNewer) {
      for (var offlineTask in offlineData ?? <TodoTaskModel>[]) {
        // التحقق مما إذا كانت المهمة المحلية موجودة على السيرفر
        final bool isTaskExistsOnline =
            onlineData.docs.any((element) => element.id == offlineTask.id);

        final taskRef = userDoc.collection('tasks').doc(offlineTask.id);

        if (isTaskExistsOnline) {
          // جلب وقت آخر تحديث للمهمة من السيرفر
          var lastUpdatedAt = (await taskRef.get())['updatedAt'] ?? DateTime(1999);
          final bool isOnlineTaskNewer =
              (lastUpdatedAt as Timestamp).toDate().isAfter(
                    offlineTask.updatedAt ?? DateTime(1999),
                  );

          if (!isOnlineTaskNewer) {
            // تحديث المهمة على السيرفر إذا كانت المهمة المحلية أحدث
            await taskRef.update(offlineTask.toJson());
          }
        } else {
          // إضافة المهمة إلى السيرفر إذا لم تكن موجودة
          await taskRef.set(offlineTask.toJson());
        }
      }
    }

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

  @override
  Future<bool> updateLastDataUpdate() async {
    try {
      final currentUser = await FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await source.collection('users').doc(currentUser);
      await userDoc.set({'lastDataUpdate': Timestamp.fromDate(DateTime.now())});
      return true;
    } catch (e) {
      return false;
    }
  }
}
