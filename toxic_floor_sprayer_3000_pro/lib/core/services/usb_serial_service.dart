import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';

class UsbSerialService {
  UsbPort? _port;

  Future<bool> connect() async {
    try {
      final devices = await UsbSerial.listDevices();

      if (devices.isEmpty) {
        return false;
      }

      final device = devices.first;
      _port = await device.create();

      if (!await _port!.open()) {
        return false;
      }

      await _port!.setDTR(true);
      await _port!.setRTS(true);
      await _port!.setPortParameters(
        115200,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      return true;
    } catch (e) {
      return false;
    }
  }


  Future<void> send(String data) async {
    if (_port == null) {
      return;
    }

    final encoded = utf8.encode('$data\n');
    await _port!.write(Uint8List.fromList(encoded));
  }

  Stream<String> receive() {
    if (_port == null || _port!.inputStream == null) {
      return Stream.empty();
    }

    return _port!.inputStream!
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());
  }



  Future<void> disconnect() async {
    await _port?.close();
    _port = null;
  }
}
