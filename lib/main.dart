/**
 * @author Kenneth Terrago
 * @email kenneth.terrago@gmail.com
 * @create date 2021-11-11 10:47:07
 * @modify date 2021-11-11 10:47:07
 * @desc This app is a sample app test for eigital
 */

import 'package:eigital_sample_app/views/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'manager/location_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocationManager().init();
  runApp(const EigitalApp());
}

class EigitalApp extends StatelessWidget {
  const EigitalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eigital Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
