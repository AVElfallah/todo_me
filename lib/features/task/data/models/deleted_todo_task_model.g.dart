// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deleted_todo_task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

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
