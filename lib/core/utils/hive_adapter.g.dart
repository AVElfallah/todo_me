// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapter.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class TodoTaskModelAdapter extends TypeAdapter<TodoTaskModel> {
  @override
  final int typeId = 0;

  @override
  TodoTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoTaskModel(
      id: fields[0] as String?,
      title: fields[1] as String?,
      createdAt: fields[2] as DateTime?,
      updatedAt: fields[3] as DateTime?,
      isCompleted: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoTaskModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeletedTodoTaskModelAdapter extends TypeAdapter<DeletedTodoTaskModel> {
  @override
  final int typeId = 1;

  @override
  DeletedTodoTaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeletedTodoTaskModel(
      id: fields[0] as String?,
      deletedTime: fields[1] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DeletedTodoTaskModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deletedTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeletedTodoTaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
