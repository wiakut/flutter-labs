import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  UsbPort? _port;
  Transaction<String>? _transaction;
  String _receivedData = 'Waiting for data...';
  bool _isReading = false;

  Future<void> _connectAndRead() async {
    setState(() => _isReading = true);

    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      setState(() {
        _receivedData = 'No USB devices found';
        _isReading = false;
      });
      return;
    }

    _port = await devices[0].create();
    final bool openResult = await _port!.open();

    if (!openResult) {
      setState(() {
        _receivedData = 'Failed to open port';
        _isReading = false;
      });
      return;
    }

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    await _port!.write(Uint8List.fromList('GET\n'.codeUnits));

    _transaction = Transaction.stringTerminated(
      _port!.inputStream!,
      Uint8List.fromList([13, 10]),
    );

    _transaction!.stream.listen((data) {
      setState(() {
        _receivedData = data.trim();
        _isReading = false;
      });
      _transaction?.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    _connectAndRead();
  }

  @override
  void dispose() {
    _transaction?.dispose();
    _port?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Last message from ESP32')),
      body: Center(
        child: _isReading
            ? const CircularProgressIndicator()
            : Text(
          _receivedData,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}