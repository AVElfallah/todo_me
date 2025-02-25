import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_me/app/routers/router_manager.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/core/theme/theme_manager.dart';
import 'package:todo_me/firebase_options.dart';

import 'app/common/loading_overly.dart';
import 'features/auth/application/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ServiceLocator.setup();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
    static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    final LoadingOverlay loadingOverlay = LoadingOverlay();
    return BlocProvider(
      key: navigatorKey,
      create: (context) => ServiceLocator.I.getIt<AuthBloc>(),
      child: Builder(
        builder:(c)=> BlocListener<AuthBloc, AuthState>(
          bloc: ServiceLocator.I.getIt<AuthBloc>(),
          listener: (context, state) {
            debugPrint('current state $state');
            /* if (state is AuthLoadingState) {
              loadingOverlay.show(context);
           
            }

            else if (state is AuthFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            } */
          
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TODO ME',
            theme: ThemeManager.instance.lightTheme,
            onGenerateRoute:ServiceLocator.I.getIt<RouterManager>().onGenerateRoute,
            initialRoute: ServiceLocator.I.getIt<RouterManager>().splash,
          ),
        ),
      ),
    );
  }
}
