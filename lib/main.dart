import 'package:airbnb/model/category_model.dart';
import 'package:airbnb/model/place_model.dart';
import 'package:airbnb/provider/favorite_provider.dart';
import 'package:airbnb/view/home_page.dart';
import 'package:airbnb/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
         providers: [
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const  AppMainScreen();
                } else {
                  return  const LoginScreen();
                }
              })),
    );
  }
}

class UploadDataInFirebase extends StatelessWidget {
  const UploadDataInFirebase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              saveCategoryItems();
            },
            child: const Text(
              "Upload Data",
              style: TextStyle(color: Colors.red),
            )),
      ),
    );
  }
}
