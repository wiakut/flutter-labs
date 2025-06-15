import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/qr/qr_cubit.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QRCubit()..initialize(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan QR-code')),
        body: BlocConsumer<QRCubit, QRState>(
          listener: (context, state) {
            if (state is QRMessageReceived) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ESP32: ${state.message}')),
              );
            }
          },
          builder: (context, state) {
            if (state is QRConnecting || state is QRInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is QRError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }

            final scanned = state is QRSent;

            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: MobileScanner(
                    onDetect: (capture) {
                      final barcode = capture.barcodes.isNotEmpty
                          ? capture.barcodes[0].rawValue
                          : null;

                      if (barcode != null && !scanned) {
                        context.read<QRCubit>().sendMessage(barcode);
                      }
                    },
                  ),
                ),
                if (state is QRSending)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  )
                else if (scanned)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('QR-code scanned and sent!'),
                        ElevatedButton(
                          onPressed: () {
                            context.read<QRCubit>().resetScan();
                          },
                          child: const Text('Scan more'),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
