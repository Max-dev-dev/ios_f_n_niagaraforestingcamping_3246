import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_cubit.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacesCubit()..loadPlaces(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/main_background.png',
                  fit: BoxFit.cover,
                ),
              ),
              child ?? const SizedBox.shrink(),
            ],
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
