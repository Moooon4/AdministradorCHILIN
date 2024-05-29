// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, depend_on_referenced_packages

import 'package:chilin_administrador/src/pages/pedidos_page.dart';
import 'package:flutter/material.dart';
import 'package:chilin_administrador/src/bloc/provider.dart';
import 'package:chilin_administrador/src/pages/home_page.dart';
import 'package:chilin_administrador/src/pages/login_page.dart';
import 'package:chilin_administrador/src/pages/producto_page.dart';

import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyDW3UN2h7mwC94EhtT_j_wHL-nhknkL9yQ",
      appId: "1:543987647187:android:096771e09a47c715b38a26",
      messagingSenderId: "543987647187",
      projectId: "pupuseriachilin",
      storageBucket: "pupuseriachilin.appspot.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,

        initialRoute: 'home',
        routes: {
          'login'   : ( (context) => LoginPage() ),
          'home'    : ( (context) => HomePage() ),
          'producto': ( (context) => ProductoPage() ),
          'pedidos' : ( (context) => PedidosPage() ),
        },
        // Vamos a poner un colorcito
        theme: ThemeData(
          primaryColor: Colors.black26
        ),
      ),
    );
  }
}