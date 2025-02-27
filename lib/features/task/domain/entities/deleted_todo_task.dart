class DeletedTodoTask  {
  final String? id;
  final DateTime? deletedTime;

  DeletedTodoTask({required this.id, required this.deletedTime});

  DeletedTodoTask copyWith({String ?id,DateTime? deletedTime}) {
    return DeletedTodoTask(
      id: id ?? this.id,
      deletedTime: deletedTime ?? this.deletedTime,
    );
  }

}