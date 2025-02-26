import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';

import 'todotask_data_source.dart';

class FirebaseTodotaskDataSourceImpl extends TodoTaskDataSource<FirebaseFirestore> {
  FirebaseTodotaskDataSourceImpl(super.source);

  @override
  Future<TodoTaskModel> createTodoTask(TodoTaskModel todoTask) async {

    final currentUser= FirebaseAuth.instance.currentUser!.uid;
    source.collection('users').doc(currentUser).collection('tasks').doc('${todoTask.id}').set(todoTask.toJson());
  return todoTask;
  

    
  }

  @override
  Future<bool> deleteTodoTask(String id) async {
    final currentUser= FirebaseAuth.instance.currentUser!.uid;
   await   source.collection('users').doc(currentUser).collection('tasks').doc(id).delete();
    return true;
  }

  @override
  Stream<List<TodoTaskModel>> getTodoTasks()  {
    final currentUser= FirebaseAuth.instance.currentUser!.uid;

    // Listen to the snapshots of the tasks collection for the current user
    var snapshots = source.collection('users').doc(currentUser).collection('tasks').snapshots();
    return snapshots.map(
      (event) => event.docs.map((e) => TodoTaskModel.fromJson(e.data())).toList(),
    );
  }

  @override
  Future<TodoTaskModel> toggleTodoTask(String id) async {
    final currentUser= FirebaseAuth.instance.currentUser!.uid;
    final task = await source.collection('users').doc(currentUser).collection('tasks').doc(id).get();
    final taskData = task.data()!;
    final updatedTask = TodoTaskModel.fromJson(taskData).copyWith(isCompleted: !taskData['isCompleted']);
    await source.collection('users').doc(currentUser).collection('tasks').doc(id).update(updatedTask.toJson());
    return updatedTask;
  }

  @override
  Future<TodoTaskModel> updateTodoTask(TodoTaskModel todoTask) async {
    final currentUser= FirebaseAuth.instance.currentUser!.uid;
    source.collection('users').doc(currentUser).collection('tasks').doc(todoTask.id).update(todoTask.toJson());
    return todoTask;
  }

  
}