import 'package:flutter/material.dart';
import 'package:todo_me/features/auth/presentation/pages/splash_screen.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/task/presentation/pages/home_screen.dart';

class RouterManager {
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
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }

  //
}
