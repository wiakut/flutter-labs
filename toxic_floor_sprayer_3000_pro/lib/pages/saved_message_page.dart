import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/cubits/message/message_cubit.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessageCubit()..connectAndRead(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Last message from ESP32')),
        body: Center(
          child: BlocBuilder<MessageCubit, MessageState>(
            builder: (context, state) {
              if (state is MessageLoading) {
                return const CircularProgressIndicator();
              } else if (state is MessageError) {
                return Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                );
              } else if (state is MessageLoaded) {
                return Text(
                  state.message,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                );
              }
              return const Text('Unknown state');
            },
          ),
        ),
      ),
    );
  }
}
