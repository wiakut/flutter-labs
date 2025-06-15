import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usb_serial/usb_serial.dart';

part 'qr_state.dart';

class QRCubit extends Cubit<QRState> {
  UsbPort? _port;

  QRCubit() : super(QRInitial());

  Future<void> initialize() async {
    emit(QRConnecting());
    final devices = await UsbSerial.listDevices();

    if (devices.isNotEmpty) {
      _port = await devices[0].create();
      final opened = await _port?.open() ?? false;

      if (!opened) {
        emit(QRError('Failed to open USB port'));
        return;
      }

      await _port?.setDTR(true);
      await _port?.setRTS(true);
      await _port?.setPortParameters(
        9600,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE,
      );

      _port?.inputStream?.listen((Uint8List data) {
        final message = String.fromCharCodes(data).trim();
        if (message.isNotEmpty) {
          emit(QRMessageReceived(message));
        }
      });

      await _port?.write(Uint8List.fromList('GET\n'.codeUnits));
      emit(QRReady());
    } else {
      emit(QRError('No USB device found'));
    }
  }

  Future<void> sendMessage(String message) async {
    if (_port == null) return;

    emit(QRSending());
    await _port?.write(Uint8List.fromList('$message\n'.codeUnits));
    emit(QRSent());
  }

  void resetScan() => emit(QRReady());

  @override
  Future<void> close() {
    _port?.close();
    return super.close();
  }
}
