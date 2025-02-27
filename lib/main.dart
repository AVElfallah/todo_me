import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:todo_me/app/routers/router_manager.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/core/theme/theme_manager.dart';
import 'package:todo_me/firebase_options.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'core/utils/hive_adapter.dart';
import 'features/auth/application/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  
  Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
  


  HiveAdapters.registerAdapters();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //لتفعيل الكاشينج في الفايربيس
  // بحيث عندما يكون البرنامج اوفلاين يقوم بحفظ البيانات في الكاشنج
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  ServiceLocator.setup();
 

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
    static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: navigatorKey,
      create: (context) => ServiceLocator.I.getIt<AuthBloc>(),
      child: Builder(
        builder:(c)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TODO ME',
          theme: ThemeManager.instance.lightTheme,
          onGenerateRoute:ServiceLocator.I.getIt<RouterManager>().onGenerateRoute,
          initialRoute: ServiceLocator.I.getIt<RouterManager>().splash,
        ),
      ),
    );
  }
}
