import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rensys_shop/home_page.dart';
import 'package:rensys_shop/providers/back_event_notifier.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ChangeNotifier>(
    create: (context) => BackEventNotifier(),
    child: const MyApp())
    
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rensys Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Webpage(),
    );
  }
}
