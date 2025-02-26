

class TodoTask  {

  final String? id;

  final String? title;
  
  final DateTime? createdAt;
  
  final DateTime? updatedAt;
 
  final bool? isCompleted;

 TodoTask({this.id, this.title, this.createdAt, this.updatedAt, this.isCompleted});
  
  TodoTask.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'isCompleted': isCompleted,
      };

  TodoTask copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return TodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  
}