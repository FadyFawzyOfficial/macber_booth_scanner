import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/qr_scanner_page.dart';
import 'providers/sales_man_provider.dart';
import 'providers/visitor_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => VisitorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalesManProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: QRScannerPage(),
      ),
    );
  }
}
