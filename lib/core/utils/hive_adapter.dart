import 'package:hive_ce/hive.dart';
import 'package:todo_me/features/task/data/models/deleted_todo_task_model.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';


part 'hive_adapter.g.dart';

@GenerateAdapters([
  AdapterSpec<TodoTaskModel>(),
  AdapterSpec<DeletedTodoTaskModel>()
])

class HiveAdapters {
  static void registerAdapters() {
    Hive.registerAdapter(TodoTaskModelAdapter());
    Hive.registerAdapter(DeletedTodoTaskModelAdapter());
  }
}