import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:usb_serial/transaction.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  UsbPort? _port;
  Transaction<String>? _transaction;

  MessageCubit() : super(MessageLoading());

  Future<void> connectAndRead() async {
    emit(MessageLoading());

    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      emit(MessageError('No USB devices found'));
      return;
    }

    _port = await devices[0].create();
    final opened = await _port?.open() ?? false;

    if (!opened) {
      emit(MessageError('Failed to open port'));
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

    await _port?.write(Uint8List.fromList('GET\n'.codeUnits));

    _transaction = Transaction.stringTerminated(
      _port!.inputStream!,
      Uint8List.fromList([13, 10]),
    );

    _transaction!.stream.listen(
      (data) {
        final message = data.trim();
        emit(MessageLoaded(message));
        _transaction?.dispose();
      },
      onError: (e) => emit(MessageError(e.toString())),
    );
  }

  @override
  Future<void> close() async {
    _transaction?.dispose();
    await _port?.close();
    return super.close();
  }
}
