part of 'qr_cubit.dart';

abstract class QRState {}

class QRInitial extends QRState {}

class QRConnecting extends QRState {}

class QRReady extends QRState {}

class QRSending extends QRState {}

class QRSent extends QRState {}

class QRMessageReceived extends QRState {
  final String message;
  QRMessageReceived(this.message);
}

class QRError extends QRState {
  final String message;
  QRError(this.message);
}
