import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_me/core/usecases/usecase.dart';
import 'package:todo_me/features/auth/domain/usecases/auth_usecase.dart';
import 'package:todo_me/features/auth/presentation/pages/splash_screen.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/task/presentation/bloc/task_bloc.dart';
import '../../features/task/presentation/pages/home_screen.dart';
import '../service_locator.dart';

class RouterManager {
  NavigatorState? navigatorKey;
  // app route paths
  // مسارات التطبيق
  final String splash = '/';
  final String login = '/login';
  final String register = '/register';
  final String home = '/home';
  //

  // on generate route
  // هنا نقدر نضيف  طبقة فوق الصفحة قبل ما نروح ليها عشان  ننفذ عليها شرط معين
  // we can add for example a check for the user to be logged in before going to the home page
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      // check if the user is authenticated or not
     
        final isAuthenticated =
            ServiceLocator.I.getIt<CheckUserAuthenticationUseCase>().call(NoParms());

        return MaterialPageRoute(
          builder:

          // future builder work as a meddle ware to check if the user is authenticated or not
           // هنا نقدر نضيف  طبقة فوق الصفحة قبل ما نروح ليها عشان  ننفذ عليها شرط معين
              (_) => FutureBuilder(
                future: isAuthenticated,
                builder: (_, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) {
                    return const Center(child: Text('Error'));
                  }
                  if (snap.hasData) {
                 return   snap.data!.fold<Widget>(
                      (error) {
                        return const SplashScreen();
                      },
                      (isLogIn) {
                        return isLogIn ? BlocProvider<TodoTaskBloc>(create: (_)=>TodoTaskBloc(ServiceLocator.I.getIt),child:HomeScreen()) : SplashScreen();
                      },
                    );
                  }
                  // default
                  else{
                    return const SplashScreen();
                  }
                },
              ),
          settings: settings,
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => BlocProvider<TodoTaskBloc>(create: (_)=>TodoTaskBloc(ServiceLocator.I.getIt),child: HomeScreen()));
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

  //
}
