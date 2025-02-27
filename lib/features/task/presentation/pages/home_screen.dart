import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:todo_me/features/task/data/models/todo_task_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_me/core/theme/app_colors.dart';
import 'package:todo_me/features/task/presentation/bloc/task_bloc.dart';
import 'package:todo_me/features/task/presentation/bloc/task_state.dart';
import 'package:todo_me/features/task/presentation/widgets/task_line_widget.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../bloc/task_event.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/note_page_widget.dart';
import '../widgets/add_new_task_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final Future<Box<TodoTaskModel>> _taskBoxFuture;


  @override
  void initState() {
    super.initState();

    _taskBoxFuture = Hive.openBox<TodoTaskModel>('tasks');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoTaskBloc>().add(SyncTodoTaskEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<TodoTaskBloc, TaskState>(
      listener: (BuildContext context, TaskState state) {

        debugPrint("UI was rebuild with state: $state");
        switch (state) {
          case TaskLoadingState():
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.info(message: "Loading Tasks Please Wait..."),
            );

            break;
          case TaskDeletedState():
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(message: "Task Deleted Successfully"),
            );
            break;
          case TaskCreatedState():
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(message: "Task Created Successfully"),
            );
            break;
          case TaskUpdatedState():
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(message: "Task Updated Successfully"),
            );
            break;
          case TodoTaskErrorState():
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: "There is an error please try again",
              ),
            );
            break;
          default:
        }
      },
      builder: (BuildContext context, TaskState state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: _appBarLayout(),
          drawer: HomeCustomDrawer(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: SvgPicture.asset(
                  'assets/svgs/note_pin.svg',

                  width: size.width * .5,
                  height: size.height * .09,
                  fit: BoxFit.fill,
                ),
              ),
             FutureBuilder(
                future: _taskBoxFuture,
                builder: (context, snapshot) {
                  return NotePageWidget(
                    containerColor: Colors.white,
                    children: [
                      AddNewTaskWidget(height: size.height * .065),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Center(child: CircularProgressIndicator()),

                      if (snapshot.connectionState == ConnectionState.done)  
                  
                      ValueListenableBuilder(
                        valueListenable:
                            snapshot.data!.listenable(),
                        builder: (context, modelDTOBox, _) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: modelDTOBox.length,
                            itemBuilder: (context, index) {
                              return TaskLineWidget(
                                key: ValueKey(modelDTOBox.getAt(index)?.id),
                                todoTask: modelDTOBox.getAt(index)!.toEntity(),
                                height: size.height * .065,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                }
              ),
            ],
          ),
        );
      },
    );
  }

  AppBar _appBarLayout() {
    return AppBar(
      title: const Text('Todo Me'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.appBarColor,
      foregroundColor: Colors.white,
      elevation: 10,
    );
  }
}
