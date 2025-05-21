import 'package:flutter/material.dart';
import 'package:toxic_floor_sprayer_3000_pro/core/storage/sprayer_storage_impl.dart';
import 'package:toxic_floor_sprayer_3000_pro/data/models/sprayer_model.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_app_bar.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_button.dart';
import 'package:toxic_floor_sprayer_3000_pro/widgets/toxic_text_field.dart';

class ConfigurationsPage extends StatefulWidget {
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
  State<ConfigurationsPage> createState() => _ConfigurationsPageState();
}

class _ConfigurationsPageState extends State<ConfigurationsPage> {
  late final TextEditingController _powerController;
  late final TextEditingController _intervalController;
  String _selectedMode = 'Auto';

  final _modes = ['Auto', 'Manual', 'ToxicBoost'];
  final _sprayerStorage = SprayerStorageImpl();

  @override
  void initState() {
    super.initState();
    _powerController = TextEditingController(text: widget.sprayer.config.power.toString());
    _intervalController = TextEditingController(text: widget.sprayer.config.interval.toString());
    _selectedMode = widget.sprayer.config.mode;
  }

  Future<void> _saveConfig() async {
    final updated = SprayerModel(
      id: widget.sprayer.id,
      name: widget.sprayer.name,
      config: SprayerConfig(
        power: int.tryParse(_powerController.text) ?? 50,
        interval: int.tryParse(_intervalController.text) ?? 10,
        mode: _selectedMode,
      ),
    );

    await _sprayerStorage.saveSprayer(widget.userKey, updated);
    widget.onUpdated(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToxicAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ToxicTextField(
              controller: _powerController,
              label: 'Power (0–100)',
            ),
            const SizedBox(height: 20),

            ToxicTextField(
              controller: _intervalController,
              label: 'Interval (sec)',
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: _selectedMode,
              dropdownColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Mode',
                labelStyle: TextStyle(color: Colors.greenAccent),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent),
                ),
              ),
              items: _modes.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedMode = value!),
            ),

            const SizedBox(height: 40),
            ToxicButton(
              onPressed: _saveConfig,
              text: 'Save Configuration',
              minimumSize: const Size(double.infinity, 50),
            ),
          ],
        ),
      ),
    );
  }
}
