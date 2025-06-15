import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:toxic_floor_sprayer_3000_pro/core/cubits/configuration/configuration_cubit.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class ConfigurationsPage extends StatelessWidget {
  final String userKey;
  final SprayerModel sprayer;
  final Function(SprayerModel updated) onUpdated;

  const ConfigurationsPage({
    super.key,
    required this.userKey,
    required this.sprayer,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfigurationCubit(sprayer, userKey),
      child: Scaffold(
        appBar: ToxicAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocBuilder<ConfigurationCubit, ConfigurationState>(
            builder: (context, state) {
              return Column(
                children: [
                  ToxicTextField(
                    label: 'Power (0–100)',
                    controller: TextEditingController(text: state.power),
                    onChanged: context.read<ConfigurationCubit>().updatePower,
                  ),
                  const SizedBox(height: 20),

                  ToxicTextField(
                    label: 'Interval (sec)',
                    controller: TextEditingController(text: state.interval),
                    onChanged: context.read<ConfigurationCubit>().updateInterval,
                  ),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    value: state.mode,
                    dropdownColor: Colors.black,
                    decoration: const InputDecoration(
                      labelText: 'Mode',
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                    items: ['Auto', 'Manual', 'ToxicBoost'].map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) => context.read<ConfigurationCubit>().updateMode(value!),
                  ),
                  const SizedBox(height: 40),

                  ToxicButton(
                    text: 'Save Configuration',
                    minimumSize: const Size(double.infinity, 50),
                    onPressed: () async {
                      await context.read<ConfigurationCubit>().save(onUpdated);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
