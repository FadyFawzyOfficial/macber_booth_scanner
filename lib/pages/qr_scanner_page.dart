import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_example/pages/qr_scanner_page2.dart';
import 'package:qr_code_example/providers/visitor_provider.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  late VisitorProvider visitorProvider;
  final qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? qrViewController;
  Barcode? barcode;

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the
  // platform is android, or resume the camera if the platform is iOS.
  //! Fix the hot reload for the camera on Android and iOS, so this code is
  //! needed to let the hot reloaded works without any issue.
  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) await qrViewController!.pauseCamera();

    qrViewController!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    visitorProvider = Provider.of<VisitorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visitors Scanner'),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            // Show the result of scanned qrcode (in toast message)
            Positioned(bottom: 24, child: buildResult()),
            // Show 2 button to control the camera flash and side (front & back)
            Positioned(top: 24, child: buildControlButtons()),
          ],
        ),
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderWidth: 10,
          borderLength: 20,
          borderRadius: 10,
          borderColor: Theme.of(context).accentColor,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController qrViewController) {
    setState(() => this.qrViewController = qrViewController);

    // So is our qr code created (scanned) for the first time,
    // so we want to listen to our scanned data and get the qr code
    // that the camera scanned for us.
    // Then we want to store this inside our state with a barcode variable.
    qrViewController.scannedDataStream.listen((scanData) async {
      setState(() => this.barcode = scanData);

      //* Note that because onQRViewCreated function listens to a stream it will
      //* fire multiple times before we can check the result.
      //! This could lead to launching multiple instances of the same page.
      //* To prevent that we pause and resume camera work when we check for
      //* validity of found data.
      qrViewController.pauseCamera();

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Visitor Data'),
          content: FutureBuilder(
            future: visitorProvider.getVisitor(barcode!.code),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.error != null)
                // Do error handling stuff here
                return Center(child: Text('Check your internet conection'));
              else
                return Consumer<VisitorProvider>(
                  builder: (context, visitor, child) =>
                      Text('Visitor: ${visitor.visitor!.name}'),
                );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerPage2(
                        visitorName: visitorProvider.visitor!.name),
                  ),
                ).then((_) => qrViewController.resumeCamera());
              },
              child: const Text('OK'),
            ),
          ],
        ),
        // Note that we resume camera work only after the user closes the dialog.
      ).then((_) => qrViewController.resumeCamera());
    });
  }

  Widget buildResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        barcode != null ? 'Result: ${barcode!.code}' : 'Scan a code!',
        maxLines: 3,
      ),
    );
  }

  Widget buildControlButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            // Display Flash icon depend on Flash Status of Camera
            icon: FutureBuilder<bool?>(
                future: qrViewController?.getFlashStatus(),
                builder: (context, snapshot) {
                  if (snapshot.data != null)
                    return snapshot.data!
                        ? Icon(Icons.flash_on_rounded)
                        : Icon(Icons.flash_off_rounded);
                  else
                    return Container();
                }),
            onPressed: () async {
              await qrViewController?.toggleFlash();
              setState(() {});
            },
          ),
          IconButton(
            // Display Switch Camera Icon if camera info (front one) is available
            icon: FutureBuilder(
                future: qrViewController?.getCameraInfo(),
                builder: (context, snapshot) {
                  if (snapshot.data != null)
                    return Icon(Icons.switch_camera_rounded);
                  else
                    return Container();
                }),
            onPressed: () async {
              await qrViewController?.flipCamera();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
