import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_me/app/routers/router_manager.dart';
import 'package:todo_me/app/service_locator.dart';
import 'package:todo_me/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceLocator.setup();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO ME',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute:ServiceLocator.I.getIt<RouterManager>().onGenerateRoute,
      initialRoute: ServiceLocator.I.getIt<RouterManager>().splash,
    );
  }
}
