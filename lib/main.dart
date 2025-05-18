import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prodigenius_application/cubit/task_cubit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prodigenius_application/providers/task_provider.dart';
import 'package:prodigenius_application/screens/HomePage.dart';
import 'package:prodigenius_application/screens/LoginScreen.dart';
import 'package:prodigenius_application/screens/SignupScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:prodigenius_application/cubit/auth_cubit.dart';
import 'firebase_options.dart';


void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set preferred orientations (optional)
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => TaskCubit()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => TaskProvider(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Manager",
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}
