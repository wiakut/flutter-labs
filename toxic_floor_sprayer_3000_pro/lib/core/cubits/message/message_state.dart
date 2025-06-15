part of 'message_cubit.dart';

abstract class MessageState {}

class MessageLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final String message;
  MessageLoaded(this.message);
}

class MessageError extends MessageState {
  final String message;
  MessageError(this.message);
}
