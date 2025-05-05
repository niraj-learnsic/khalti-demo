import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

final navKey = GlobalKey<NavigatorState>();

// Replace with your actual Khalti public key and API URLs
class AppUrls {
  //This is test key
  static const String khaltiPublicKey = "c99877cc9e4840d0a5aeff030c4d842c";
  static const bool isProd = false; // Set to true for production
}

class PaymentData {
  final String pidx;
  PaymentData({required this.pidx});
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onKhaltiCall() async {
    final payConfig = KhaltiPayConfig(
      publicKey: AppUrls.khaltiPublicKey,

      //TODO: Replace with your own pidx
      pidx: "PVcTbpnBqmA4baWQ8ZTFoB",
      environment: AppUrls.isProd ? Environment.prod : Environment.test,
    );
    Khalti? khalti = await Khalti.init(
      enableDebugging: false,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log('Payment Result: $paymentResult');
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
      },
      onReturn: () async {
        log('Successfully redirected to return_url.');
      },
    );
    if (navKey.currentState!.mounted) {
      khalti.open(navKey.currentState!.context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buy Item')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Placeholder Item
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: const Text(
                'Placeholder Item',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _onKhaltiCall();
              },
              child: const Text('Buy Now with Khalti'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khalti Buy App',
      navigatorKey: navKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
