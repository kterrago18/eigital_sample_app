import 'package:eigital_sample_app/cubit/home/home_screen_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = "", _password = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter Email",
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Enter Password",
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  TextButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                          const Size.fromWidth(200)),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(15)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await _auth.signInWithEmailAndPassword(
                            email: _email, password: _password);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<HomeScreenCubit>(
                              create: (_) => HomeScreenCubit(),
                              child: const HomeScreen(),
                            ),
                          ),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                      } catch (e) {
                        debugPrint("## Email login error: $e");
                      }
                    },
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RawMaterialButton(
                        onPressed: () async {
                          await _signInWithGoogle();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<HomeScreenCubit>(
                                create: (_) => HomeScreenCubit(),
                                child: const HomeScreen(),
                              ),
                            ),
                          );
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: const FaIcon(
                          FontAwesomeIcons.google,
                          size: 35.0,
                          color: Colors.red,
                        ),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      ),
                      RawMaterialButton(
                        onPressed: () async {
                          await _signInWithFacebook(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<HomeScreenCubit>(
                                create: (_) => HomeScreenCubit(),
                                child: const HomeScreen(),
                              ),
                            ),
                          );
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        child: const FaIcon(
                          FontAwesomeIcons.facebookF,
                          size: 35.0,
                          color: Colors.blue,
                        ),
                        padding: const EdgeInsets.all(10),
                        shape: const CircleBorder(),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(googleAuthCredential);
    } catch (e) {
      debugPrint("## Gmail login error: $e");
    }
  }

  Future _signInWithFacebook(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final facebookLoginResult = await FacebookAuth.instance.login();

      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      var title = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          title =
              'Thrown if there already exists an account with the email address asserted by the credential.';
          break;
        case 'invalid-credential':
          title = 'Thrown if the credential is malformed or has expired.';
          break;
        case 'user-disabled':
          title =
              'Thrown if the user corresponding to the given credential has been disabled.';
          break;
        case 'user-not-found':
          title =
              'Thrown if signing in with a credential from [EmailAuthProvider.credential] and there is no user corresponding to the given email.';
          break;
        case 'operation-not-allowed':
          title =
              'Thrown if the type of account corresponding to the credential is not enabled. Enable the account type in the Firebase Console, under the Auth tab.';
          break;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login in with facebook failed'),
          content: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
