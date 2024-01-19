import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:super_pixel/controller/assets_controller.dart';
import 'package:super_pixel/model/asset.dart';
import 'package:super_pixel/ui/routes/app_route.dart';

class AssetScanner extends StatelessWidget {
  AssetScanner({required this.onTap, super.key});

  final Function(Asset asset) onTap;

  final MobileScannerController scannerController = MobileScannerController(
      // torchEnabled: true, useNewCameraSelector: true,
      // formats: [BarcodeFormat.qrCode]
      // facing: CameraFacing.front,
      // detectionSpeed: DetectionSpeed.normal
      // detectionTimeoutMs: 1000,
      // returnImage: false,
      );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 0.8,
      minChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: MobileScanner(
                onDetect: (barcodes) {
                  HapticFeedback.heavyImpact();
                  print('barcode is ${barcodes.barcodes.first.rawValue}');
                  if (barcodes.barcodes.first.rawValue != null) {
                    scannerController.stop();
                    var segments = barcodes.barcodes.first.rawValue!.split('/');

                    var asset = AssetsController.getInstance()
                        .value
                        .firstWhere((element) => element.id == segments.last);
                    AppRoute.pop(context);
                    onTap(asset);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
