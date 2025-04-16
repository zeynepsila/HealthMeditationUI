import 'package:flutter/material.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/meditation/meditation_screen.dart';
import '../screens/exercise/exercise_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/home/main_layout.dart';


class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const meditation = '/meditation';
  static const exercise = '/exercise';
  static const profile = '/profile';
  static const main = '/main';



  static final routes = <String, WidgetBuilder>{
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    meditation: (context) => const MeditationScreen(),
    exercise: (context) => const ExerciseScreen(),
    profile: (context) => const ProfileScreen(),
    main: (context) => const MainLayout(),


  };
}
