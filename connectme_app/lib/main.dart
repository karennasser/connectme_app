import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'injection.dart';
import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/post_cubit.dart';
import 'presentation/blocs/profile_cubit.dart';
import 'presentation/screens/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  runApp(const ConnectMeApp());
}

class ConnectMeApp extends StatelessWidget {
  const ConnectMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()..checkAuth()),
        BlocProvider(create: (_) => getIt<PostCubit>()),
        BlocProvider(create: (_) => getIt<ProfileCubit>()),
      ],
      child: MaterialApp(
        title: 'ConnectMe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6258D9)),
          scaffoldBackgroundColor: const Color(0xFFF7F7FB),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const AppRouter(),
      ),
    );
  }
}
