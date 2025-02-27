import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';
import 'package:todo_me/features/task/domain/entities/deleted_todo_task.dart';

// this class is used to store the deleted tasks in the hive database
// is a dto class

part 'deleted_todo_task_model.g.dart';

@HiveType(typeId: 1)
class DeletedTodoTaskModel extends DeletedTodoTask with HiveObjectMixin {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final DateTime? deletedTime;

  DeletedTodoTaskModel({this.id, this.deletedTime})
    : super(id: id, deletedTime: deletedTime);

  factory DeletedTodoTaskModel.fromJson(Map<String, dynamic> json) =>
      DeletedTodoTaskModel(id: json['id'], deletedTime: (json['deletedTime']as Timestamp?)?.toDate());
      

  Map<String, dynamic> toJson() => {'id': id, 'deletedTime': Timestamp.fromDate(deletedTime!)};

  DeletedTodoTask toEntity() =>
      DeletedTodoTask(id: id, deletedTime: deletedTime);

  static DeletedTodoTaskModel fromEntity(DeletedTodoTask entity) =>
      DeletedTodoTaskModel(id: entity.id, deletedTime: entity.deletedTime);
}
