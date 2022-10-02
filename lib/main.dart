import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webncraft_mt/providers/employee_provider.dart';
import 'package:webncraft_mt/screens/home_page.dart';

void main() {
  runApp(
      ChangeNotifierProvider<EmployeeDataProvider>(
          create: (_) => EmployeeDataProvider(),
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'webncraft mt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
