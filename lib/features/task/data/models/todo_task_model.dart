import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive.dart';

import '../../domain/entities/todo_task.dart';

part 'todo_task_model.g.dart';

@HiveType(typeId: 0)
class TodoTaskModel extends TodoTask with HiveObjectMixin{
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final DateTime? createdAt;
  @HiveField(3)
  final DateTime? updatedAt;
  @HiveField(4)
  final bool? isCompleted;
  

  TodoTaskModel({ this.id,  this.title,  this.createdAt, this.updatedAt, this.isCompleted});

  factory TodoTaskModel.fromJson(Map<String, dynamic> json) => TodoTaskModel(
        id: json['id'],
        title: json['title'],
        createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
        isCompleted: json['isCompleted'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': Timestamp.fromDate(createdAt!),
        'updatedAt':Timestamp.fromDate(updatedAt!) ,
        'isCompleted': isCompleted,
      };

      TodoTask toEntity() => TodoTask(
        id: id,
        title: title,
        createdAt: createdAt!,
        updatedAt: updatedAt!,
        isCompleted: isCompleted,
      );

      static TodoTaskModel fromEntity(TodoTask entity) => TodoTaskModel(
        id: entity.id,
        title: entity.title,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        isCompleted: entity.isCompleted,
      );


    TodoTaskModel  copyWith({
        String? id,
        String? title,
        DateTime? createdAt,
        DateTime? updatedAt,
        bool? isCompleted,
      }) {
        return TodoTaskModel(
          id: id ?? this.id,
          title: title ?? this.title,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          isCompleted: isCompleted ?? this.isCompleted,
        );
      }

}