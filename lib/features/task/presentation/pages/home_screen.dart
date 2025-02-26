import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/core/theme/app_colors.dart';
import 'package:todo_me/features/task/presentation/bloc/task_bloc.dart';
import 'package:todo_me/features/task/presentation/bloc/task_state.dart';
import 'package:todo_me/features/task/presentation/widgets/task_line_widget.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/task_usecase.dart';
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
  final dataStream = ServiceLocator.I.getIt<GetTodoTasksUseCase>().call(
    NoParms(),
  );
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<TodoTaskBloc>(context).add(GetTodoTasksEvent());
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
        debugPrint("state: $state");
        switch (state) {
          
          case TaskLoadingState():
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.info(message: "Loading Tasks Please Wait..."),
            );
            ;
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
              StreamBuilder(
                stream: dataStream,
                builder: (context, snapshot) {
                  return NotePageWidget(
                    containerColor: Colors.white,
                    children: [
                      if (snapshot.hasError) Center(child: Text('Error')),
                      ...[
                        AddNewTaskWidget(height: size.height * .065),
                        if (snapshot.hasData)
                          snapshot.data!.fold(
                            (error) => const Text('Error'),
                            (tasks) =>
                                tasks.isEmpty
                                    ? NotePageWidget.withEndTaskContainer()
                                    : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: tasks.length,
                                      itemBuilder: (context, index) {
                                        return TaskLineWidget(
                                          key: ValueKey(tasks[index].id),
                                          todoTask: tasks[index],
                                          height: size.height * .065,
                                        );
                                      },
                                    ),
                          ),
                      ],
                    ],
                  );
                },
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
