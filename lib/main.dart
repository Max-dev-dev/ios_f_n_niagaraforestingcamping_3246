import 'package:advertising_id/advertising_id.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_cubit.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/splash_screen.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/ver_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConstants {
  static const String oneSignalAppId = "87a0ddd0-f15e-42c1-852f-84b82109a5f3";
  static const String appsFlyerDevKey = "EsJBZj76R5fCiere38Z6Dd";
  static const String appID = "6748390760";

  static const String baseDomain = "transcendent-paramount-glee.space";
  static const String verificationParam = "IW8HPFQE";

  static const String splashImagePath = 'assets/images/splash.png';
}

const String _fallbackIdfa = '00000000-0000-0000-0000-000000000000';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await _requestTrackingAndSaveIdfa();

  final now = DateTime.now();
  final dateOff = DateTime(2024, 7, 14, 20, 00);
  final initialRoute = now.isBefore(dateOff) ? '/white' : '/verify';

  runApp(RootApp(
    initialRoute: initialRoute,
    whiteScreen: MainApp(),
  ));
}

Future<void> _requestTrackingAndSaveIdfa() async {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
    debugPrint('ATT prompt result: $newStatus');
  } else {
    debugPrint('ATT already determined: $status — діалог більше не показується');
  }
  String newIdfa;
  if (status == TrackingStatus.authorized) {
    newIdfa = await AdvertisingId.id(true) ?? _fallbackIdfa;
  } else {
    newIdfa = _fallbackIdfa;
  }

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('advertising_id', newIdfa);
  debugPrint('Saved IDFA: $newIdfa');
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
