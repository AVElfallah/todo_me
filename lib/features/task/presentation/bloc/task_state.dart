
import 'package:equatable/equatable.dart';


abstract class TaskState extends Equatable {
  const TaskState();  

  @override
  List<Object> get props => [];
}


class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskDeletedState extends TaskState {}


class TaskCreatedState extends TaskState {}
class TaskUpdatedState extends TaskState {}

class TaskToggledState extends TaskState {}

class TaskSuccessfullySyncedState extends TaskState {}
class TaskFailureSyncedState extends TaskState {}


class TodoTaskErrorState extends TaskState {
  final String message;
  TodoTaskErrorState(this.message);

  @override
  List<Object> get props => [message];
}

